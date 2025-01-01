// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract EventContract{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemaining;
    }

    mapping(uint=>Event) public events;
    mapping(address => mapping (uint => uint)) public tickets;
    uint public nextId;

    function createEvent(string memory _name,uint _date,uint _price,uint _ticketCount)  external {
        require(_date > block.timestamp,"you can organize event for future date");
        require(_ticketCount>0,"you can organize event if you create more then 0 tickets");

        events[nextId]=Event(msg.sender,_name,_date,_price,_ticketCount,_ticketCount);
        nextId++;
    }

    function buyTicket(uint _id, uint _quantity) external payable {
        require(events[_id].date != 0 , "Event does not exist");
        require(events[_id].date > block.timestamp,"Event has already occured.");
        require(_quantity>0,"Minimun 1 ticket quantity you buy");

        Event storage _event = events[_id];
        require(msg.value==(_event.price*_quantity),"Ether is not enough");
        require(_event.ticketRemaining >= _quantity,"Not enough tickets");
        _event.ticketRemaining -= _quantity;
        tickets[msg.sender][_id]+=_quantity;

    }

    function transferTicket(uint _id , uint _quantity , address to) external {
        require(events[_id].date != 0 , "Event does not exist");
        require(events[_id].date > block.timestamp,"Event has already occured.");
        require(tickets[msg.sender][_id]>=_quantity,"you do not have enough tickets");
        tickets[msg.sender][_id]-=_quantity;
        tickets[to][_id]+=_quantity;
    }
}