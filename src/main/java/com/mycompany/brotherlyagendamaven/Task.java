package com.mycompany.brotherlyagendamaven;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class Task {
    private static final DateTimeFormatter DTF1 = DateTimeFormatter.ofPattern("MM/dd/yyyy");
    private static final DateTimeFormatter DTF2 = DateTimeFormatter.ofPattern("M/d/yyyy");
    private String id;
    private String name;
    private String description;
    private LocalDate dueDate;
    
    public Task(String n, String d, String ld, String i) {
        this.id = i;
        this.name = n;
        this.description = d;
        this.dueDate = setDueDateFromString(ld);
    }
    
    public Task(String n, String d, LocalDate ld) {
        this.id = generateRandomId(n);
        this.name = n;
        this.description = d;
        this.dueDate = ld;
    }
    
    public Task(String n, String d, String ld) {
        this.id = generateRandomId(n);
        this.name = n;
        this.description = d;
        this.dueDate = setDueDateFromString(ld);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }
    
    public LocalDate setDueDateFromString(String dueDateText) {
        LocalDate ld = null;
        Pattern p = Pattern.compile("([0-9]{2})/([0-9]{2})/([0-9]{4})");
        Matcher m = p.matcher(dueDateText);
        try {
            if(m.matches()) {
                ld = LocalDate.parse(dueDateText, DTF1);
            } else {
                ld = LocalDate.parse(dueDateText, DTF2);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ld;
    }

    public String getId() {
        return id;
    }
    
    private String generateRandomId(String n) {
        Random rng = new Random();
        return n + ThreadLocalRandom.current().nextInt(99999 - 10000);
    }
}
