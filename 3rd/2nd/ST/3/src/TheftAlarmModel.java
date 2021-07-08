import nz.ac.waikato.modeljunit.Action;
import nz.ac.waikato.modeljunit.FsmModel;

public class TheftAlarmModel implements FsmModel {

    private enum State { DISARMED_OPEN,
                         DISARMED_CLOSED,
                         ARMED_CLOSED,
                         ARMED_OPEN};

    private State state;
    private Boolean ready = false;
    private int blinks = 0;

    TheftAlarmTestAdapter adapter = new TheftAlarmTestAdapter();

    public TheftAlarmModel () {
        this.reset(true);
        adapter.resetSUT();
    };

    @Override
    public Object getState() {
        return state;
    }

    @Override
    public void reset(boolean b) {
        this.state = State.DISARMED_OPEN;
        this.ready = false;
        this.blinks = 0;
    }

    @Action
    public void arm() {
        ready = true;
        switch (this.state){
            case DISARMED_CLOSED -> {state = State.ARMED_CLOSED; blinks = 1;}
            default              -> {blinks = 0;}
        }
        adapter.armSUT(blinks);
    }



    @Action
    public void disarm() {
        ready = false;
        switch (this.state){
            case ARMED_OPEN   -> {state = State.DISARMED_OPEN; blinks = 2;}
            case ARMED_CLOSED -> {state = State.DISARMED_CLOSED; blinks = 2;}
            default           -> {blinks = 0;}
        }
        adapter.disarmSUT(blinks);
    }


    @Action
    public void closeDoors() {
        switch (this.state){
            case ARMED_OPEN    -> {state= State.ARMED_CLOSED;blinks=1;}
            case DISARMED_OPEN -> {if(ready){state=State.DISARMED_CLOSED;blinks = 0;}else{state=State.ARMED_CLOSED;blinks=1;}}
            default            -> {blinks=1;}
        }
        adapter.closeDoorsSUT(blinks);
    }

    public boolean closeDoorsGuard() {
        return state != State.ARMED_CLOSED && state != State.DISARMED_CLOSED;
    }


    @Action
    public void openDoors() {
        switch (this.state){
            case ARMED_CLOSED    -> {state= State.ARMED_OPEN;blinks=27;}
            case DISARMED_CLOSED -> {state=State.DISARMED_OPEN;blinks=0;}
            default              -> {blinks=-1;}
        }
        adapter.openDoorsSUT(blinks);
    };

    public boolean openDoorsGuard() {
        return state != State.ARMED_OPEN && state != State.ARMED_CLOSED;
    }



}
;