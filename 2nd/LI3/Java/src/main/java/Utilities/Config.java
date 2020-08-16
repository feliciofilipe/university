package Utilities;

public abstract class Config {
    /**
     * Default path of the clients file
     */
    public static String clientsPath = "data/Clientes.txt";

    /**
     * Default path of the products file
     */
    public static String productsPath = "data/Produtos.txt";

    /**
     * Default path of the sales file 1M lines
     */
    public static String salesFile1M = "data/Vendas_1M.txt";

    /**
     * Default path of the sales file 3M lines
     */
    public static String salesFile3M = "data/Vendas_3M.txt";

    /**
     * Default path of the sales file 5M lines
     */
    public static String salesFile5M = "data/Vendas_5M.txt";

    /**
     * Folder where to store and load the objects
     */
    public static String objectsFolder = "objects/";

    /**
     * Default name of the data object
     */
    public static String objectName = "guestVendas.dat";

    /**
     * Number of branches in the apllication
     */
    public static int numberOfBranches = 3;

    /**
     * Number of sale types in the apllication
     */
    public static int numberOfSaleTypes = 2;

    /**
     *  Code for Normal Sales
     */
    public static int saleN = 0;

    /**
     *  Code for Promotional Sales
     */
    public static int saleP = 1;

    /**
     * Number of the lowest month allowed
     */
    public static int minMonth = 1;

    /**
     * Number of the highest month allowed
     */
    public static int maxMonth = 12;

    /**
     * Number of clients/products in a view page
     */
    public static int pageSize = 15;

}
