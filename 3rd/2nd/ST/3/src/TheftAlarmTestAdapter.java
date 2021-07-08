import theft_alarm_v5.Alarm;

import static org.junit.Assert.assertEquals;

public class TheftAlarmTestAdapter {
    Alarm sut = new Alarm();

    public void resetSUT(){
        sut.reset();
    }

    public void closeDoorsSUT(int expected) {
        assertEquals(expected, sut.closeDoors());
    }

    public void openDoorsSUT(int expected) {
        assertEquals(expected, sut.openDoors());
    }

    public void armSUT(int expected) {
        assertEquals(expected, sut.arm());
    }

    public void disarmSUT(int expected) {
        assertEquals(expected, sut.disarm());
    }

}
