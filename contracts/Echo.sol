// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Echo {

    enum State {
        Pending,
        Success,
        Fail
    }

    struct Donate {
        address from;
        uint amount;
    }

    mapping(uint => Donate[]) activitySender;

    struct Activity {
        uint id;
        address creator;
        string title;
        string description;
        uint value;
        uint amount;
        uint deadline;
        uint minValue;
        uint minValuePercent;
        State state;
        uint finishedTime;
        uint createAt;
    }

    receive() external payable { }

    fallback() external payable {}

    event Pay(uint _activityId,address sender,uint value,uint timeAt);

    uint public activityId;
    Activity[] activity;

    modifier formValidate(uint value,uint deadline,uint minValue,uint minValuePercent) {
        require(value > 0, unicode"最少要大于0");
        require(deadline > (block.timestamp + 15), unicode"超时了");
        require(minValue > 0, unicode"最小金额要大于0");
        require(minValuePercent >= 50, unicode"minValuePercent is invalid");
        _;
    }

    function createActivity(string[2] memory attr,
        uint value,uint deadline,uint minValue,uint minValuePercent) external 
        formValidate(value,deadline,minValue,minValuePercent) {
            Activity memory _activity;
            _activity.id = ++activityId;
            _activity.creator = msg.sender;
            _activity.title = attr[0];
            _activity.description = attr[1];
            _activity.value = value;
            _activity.deadline = deadline;
            _activity.minValue = minValue;
            _activity.minValuePercent = minValuePercent;
            _activity.state = State.Pending;
            _activity.createAt = block.timestamp;
            activity.push(_activity);
        }

    
    function pay(uint _activityId) external payable {
        uint index = _activityId - 1;
        require(_activityId <= activityId,unicode"Id不存在");
        require(activity[index].state == State.Pending,unicode"活动已经结束");
        require(msg.value >= activity[index].minValue,unicode"最小金额不不正确");
        require(activity[index].deadline > block.timestamp,unicode"区块时间错误，已超时");
        uint value = msg.value;
        activity[index].amount += value;
        Donate memory _activitySender;
        _activitySender.from = msg.sender;
        _activitySender.amount = value;
        activitySender[index].push(_activitySender);

        emit Pay(_activityId,msg.sender,msg.value,block.timestamp);
    }


    function finish(uint _activityId) external {
        uint index = _activityId - 1;
        require(_activityId <= activityId,unicode"Id不存在");
        require(activity[index].state == State.Pending,unicode"活动已经结束");
        require(activity[index].creator == msg.sender, unicode"没有权限");
        if(activity[index].amount >= activity[index].value){
            uint v = activity[index].amount;
            payable(activity[index].creator).transfer(v);
            activity[index].finishedTime = block.timestamp;
            activity[index].state = State.Success;
        } else {
            if(activity[index].deadline <= block.timestamp) {
                for(uint n;n<activitySender[index].length;n++){
                    address sender = activitySender[index][n].from;
                    uint v = activitySender[index][n].amount;
                    payable(sender).transfer(v);
                }
                activity[index].state = State.Fail;
            }
        }
    }

    function getActivity(uint _activityId) external view returns(bool,Activity memory){
        Activity memory _activity;
        if(_activityId > activityId || _activityId <= 0){
            return (false,_activity);
        }
        return (true, activity[_activityId-1]);
    }

    function getActivityList() external view returns (Activity[] memory){
        return activity;
    }

}