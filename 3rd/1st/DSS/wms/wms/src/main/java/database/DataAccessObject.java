package database;

import java.util.List;

public class DataAccessObject<K, O> {
    private String table;
    private List<String> columns;
    private DataClass<K> token;
}
