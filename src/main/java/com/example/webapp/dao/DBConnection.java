package com.example.webapp.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:sqlserver://localhost:60871;"
                    + "databaseName=servlet_demo;"
                    + "encrypt=true;"
                    + "trustServerCertificate=true;";

    private static final String USERNAME = "sa";
    private static final String PASSWORD = "123456";

    public static Connection getConnection() {
        try {
            // Load SQL Server JDBC Driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            return DriverManager.getConnection(
                    URL,
                    USERNAME,
                    PASSWORD
            );

        } catch (ClassNotFoundException e) {
            System.err.println("SQL Server JDBC Driver not found!");
            e.printStackTrace();

        } catch (SQLException e) {
            System.err.println("Connection to SQL Server failed!");
            e.printStackTrace();
        }

        return null;
    }
}