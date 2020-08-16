package Controller;

import Model.Transporter;
import Model.Exceptions.InvalidIDException;
import Model.Model;
import View.View;

public class MedicalSupliesVolunteerInteractiveController extends VolunteerInteractiveController implements MedicalSupliesVolunteerInterface {
        /**
         * Parameterized Constructor
         * @param model Model of the system
         * @param view View of the system
         * @param ID ID of the carrier
         */
        public MedicalSupliesVolunteerInteractiveController(Model model, View view, String ID){
            super(model,view,ID);
        }
}
