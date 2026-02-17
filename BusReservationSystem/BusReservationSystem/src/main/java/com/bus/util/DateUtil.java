package com.bus.util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {

    private static final String FORMAT = "dd-MM-yyyy";

    public static String formatDate(Date date) {

        SimpleDateFormat sdf = new SimpleDateFormat(FORMAT);
        return sdf.format(date);
    }

    public static Date parseDate(String dateStr) {

        try {
            SimpleDateFormat sdf = new SimpleDateFormat(FORMAT);
            return sdf.parse(dateStr);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}