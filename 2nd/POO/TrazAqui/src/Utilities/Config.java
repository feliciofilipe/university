package Utilities;

public class Config {

    public static String logsFile = "data/logs.txt";
    public static String EnterToContinue = "Press \"ENTER\" To Continue";
    public static String InvalidOption = "Invalid Option";
    public static String InvalidInput = "Invalid Input";
    public static String Carrier = "Carrier";
    public static String ObjectsFile = "data/file.bin";
    public static String ErrorWithInput = "Error With The Input Provided";
    public static String EntityDoesntExist = "Entitie Doesn't Exists";
    public static String InvalidTransporter = "Not a valid transporter ID.";
    public static String InvalidID = "Invalid ID";
    public static String ProductAlreadyExists = "The Product with this description already exists in your Store Catalog";
    public static String CartIsEmpty = "The Cart is Empty";
    public static String TransporterOfferAccepted = "Transporter Offer accepted, your package should be on the way :)";
    public static String ThanksForFeedback = "Thanks for giving us your feedback :)";
    public static String PleaseRateBetween = "Please give a rating between 0.0 and 10.0";
    public static String OfferSuccess = "Offer made with success - waiting User approval";
    public static String MaxNumberOfOrders = "Already reach the MAX number of Orders for this Carrier";
    public static String ThanksFroAcceptingOffer = "Thanks for accepting this Offer, the User will be expecting you in his location :)";
    public static String BibleMessage = "This should not be reached because I dont allowed it, but in any case here is this message error: \n " + " Genesis 1:3 And God said, \"Let there be light,\" and there was light.";
    public static String OrderAlreadyOnDelivery = "This order is already on delivery";
    public static String NotAllowedToAcceptOffer = "You are not allowed to accept this offer";
    public static String YourPassword(String password) {return "Your Password: " + password;}
    public static String ProductAdded(String productID, String description) {return "Product: " + productID + " - " + description + " added to the Catalog";}
    public static String StoreDoesntExists(String storeID) {return "The store with ID:" + storeID + "does not exist";}
    public static String AddToCart(Double quantity, String productID) {return quantity + " units of: " + productID + " added to the Cart";}
    public static String ProductDoesntExists(String productID) {return "The product with ID:" + productID + " does not exist within this Store";}
    public static String UserIDDoesntExists(String userID) {return "User with ID:" + userID + " does not exist";}
    public static String OrderDoesntHaveOffer(String orderID, String transporterID) {return "An Order with ID: " + orderID + " does have an offer from an Transporter with ID: " + transporterID ;}
    public static String OrderDoesntExists(String orderID) {return "An Order with ID: " + orderID + " does not exist";}
    public static String OrderWaitingForRating(String orderID) {return "An Order with ID: " + orderID + " is not waiting for rating from this User";}
    public static String TransporterDoesntExists(String transporterID) {return "Transporter with ID: " + transporterID + " does not exit";}
    public static String OrderDoesntHaveOfferFromVolunteer(String orderID, String volunteerID) {return "An Order with ID: " + orderID + " does have an offer from an Volunteer with ID: " + volunteerID;}
    public static String VolunteerDoesntExists(String volunteerID) {return "Volunteer with ID:" + volunteerID + " does not exist";}
    public static String CorrectlySet(String something) {return something +  " Correctly Set";}
    public static String ErrorSetting(String something) {return "Error Setting " + something;}
    public static String ErrorValidating(String something) {return "Error Validating " + something;}

}
