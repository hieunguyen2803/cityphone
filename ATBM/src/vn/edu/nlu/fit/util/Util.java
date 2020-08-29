package vn.edu.nlu.fit.util;

import vn.edu.nlu.fit.model.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.DecimalFormat;

public class Util {
    static final String HOST = "http://localhost:8080/web_mobile/";
//    static final String HOST = "http://webmobile.jl.serv.net.mx/";

    public static String fullPath(String path) {
        return HOST + path;
    }

    public static String convertPrice(double price) {
        BigDecimal decimal = new BigDecimal(price);

        DecimalFormat format = new DecimalFormat("####,###,###");

        String pri = (String.valueOf(format.format(decimal)) + "đ").replace(",", ".");

        return pri;
    }

    public static String splitImg(String listLink) {
        String[] link = listLink.split("~");
        return link[0];
    }

}
