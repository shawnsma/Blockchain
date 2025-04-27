// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract RockPaperScissors{
    enum Move { None, Rock, Paper, Scissors }
    enum State { None, Create, Join, Commit, Reveal, Finish}

    struct Game {
        address payable p1;
        address payable p2;
        bytes32 decision1;
        bytes32 decision2;
        Move move1;
        Move move2;
        uint256 bet;
        State state;
        uint256 time;
        uint256 wins1;
        uint256 wins2;
        uint256 winsneeded;
    }

    mapping(uint256 => Game) public games;
    uint256 counter;
    uint256 fee;
    address payable public owner;
    uint256 public constant TIMEOUT = 2 minutes;
    uint256 public constant CONTRACTFEE = 5;

    event Created(uint256 gameId, address p1, uint256 bet);
    event Joined(uint256 gameId, address p2);
    event Committed(uint256 gameId, address p);
    event Revealed(uint256 gameId, address p, Move move);
    event GameWon(uint256 gameId, address winner, uint256 amount);
    event RoundWon(uint256 gameId, address winner);

    constructor(uint256 _regfee) {
        fee = _regfee;
        owner = payable(msg.sender);
    }

    function createGame(bytes32 _commit, uint256 _winsneeded) external payable returns (uint256){
        require(msg.value == fee, "Registration fee incorrect");

        uint256 gameId = counter++;
        games[gameId] = Game({
            p1: payable(msg.sender),
            p2: payable(address(0)),
            decision1: _commit,
            decision2: bytes32(0),
            move1: Move.None,
            move2: Move.None,
            bet: msg.value,
            state: State.Create,
            time: block.timestamp,
            wins1: 0,
            wins2: 0,
            winsneeded: _winsneeded
        });

        emit Created(gameId, msg.sender, msg.value);
        return gameId;
    }

    function joinGame(uint256 _gameId, bytes32 _commit) external payable {
        Game storage game = games[_gameId];
        require(game.state == State.Create, "Game not available");
        require(msg.value == game.bet, "Registration fee incorrect");
        require(msg.sender != game.p1, "Cannot play against yourself");

        game.p2 = payable(msg.sender);
        game.decision2 = _commit;
        game.state = State.Commit;
        game.time = block.timestamp;

        emit Joined(_gameId, msg.sender);
    }

    function reveal(uint256 _gameId, Move _move, bytes32 _salt) external {
        Game storage game = games[_gameId];
        require(game.state == State.Commit, "Cannot reveal");
        require(block.timestamp <= game.time + TIMEOUT, "Reveal timeout");

        bytes32 commitment = keccak256((abi.encodePacked(_move, _salt)));

        if (msg.sender == game.p1) {
            require(commitment == game.decision1, "Invalid move");
            game.move1 = _move;
        } else if (msg.sender == game.p2) {
            require(commitment == game.decision2, "Invalid move");
            game.move2 = _move;
        } else{
            revert("Not a secured player");
        }

        emit Revealed(_gameId, msg.sender, _move);

        if (game.move1 != Move.None && game.move2 != Move.None) {
            _resolveRound(_gameId);
        }
    }

    function _resolveRound(uint256 _gameId) internal {
        Game storage game = games[_gameId];
        address payable winner;

        if (game.move1 == game.move2) {
            game.move1 = Move.None;
            game.move2 = Move.None;
            game.decision1 = bytes32(0);
            game.decision2 = bytes32(0);
            game.state = State.Join;
            return;
        }

        if ((game.move1 == Move.Rock && game.move2 == Move.Scissors) || (game.move1 == Move.Paper && game.move2 == Move.Rock) || (game.move1 == Move.Scissors && game.move2 == Move.Paper)) {
            game.wins1++;
            winner = game.p1;
        } else {
            game.wins2++;
            winner = game.p2;
        }

        emit RoundWon(_gameId, winner);

        if (game.wins1 == game.winsneeded || game.wins2 == game.winsneeded){
            _finalizeGame(_gameId, winner);
        } else {
            game.move1 = Move.None;
            game.move2 = Move.None;
            game.decision1 = bytes32(0);
            game.decision2 = bytes32(0);
            game.state = State.Join;
        }
    }

    function _finalizeGame(uint256 _gameId, address payable _winner) internal {
        Game storage game = games[_gameId];
        uint256 prize = game.bet * 2;
        uint256 ownerfee = (prize * CONTRACTFEE) / 100;
        uint256 earning = prize - ownerfee;

        owner.transfer(ownerfee);
        _winner.transfer(earning);

        game.state = State.Finish;
        emit GameWon(_gameId, _winner, earning);
    }


    function timeoutReveal(uint256 _gameId) external {
        Game storage game = games[_gameId];
        require(game.state == State.Commit, "Not in commit phase");
        require(block.timestamp > game.time + TIMEOUT, "Timeout not reached");
        
        if (game.move1 == Move.None && game.move2 != Move.None) {
            _finalizeGame(_gameId, game.p2);
        } else if (game.move1 != Move.None && game.move2 == Move.None) {
            _finalizeGame(_gameId, game.p1);
        } else {
            // Both players failed to reveal - return funds
            game.p1.transfer(game.bet);
            game.p2.transfer(game.bet);
            game.state = State.Finish;
        }
    }
}