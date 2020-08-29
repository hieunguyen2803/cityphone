package vn.edu.nlu.fit.controller.admin;

import vn.edu.nlu.fit.dao.ItemsDAO;
import vn.edu.nlu.fit.model.Item;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/items")
public class admin_items extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        try {
            String action = request.getParameter("action");
            String id_items = request.getParameter("id_items");
            String name_items = request.getParameter("name_items");

            if (action == null) {
                List<Item> list = new ItemsDAO().listItems();
                request.setAttribute("list", list);
                request.getRequestDispatcher("admin_items.jsp").forward(request, response);

            } else if (name_items != null && id_items != null && action.equals("add")) {
                boolean add = new ItemsDAO().addItems(id_items, name_items);
                if (add == true) {
                    response.getWriter().write("Thêm " + name_items + " thành công.");
                } else {
                    response.getWriter().write("Lỗi thêm " + name_items);
                }
            } else if (name_items != null && id_items != null && action.equals("edit")) {
                boolean edit = new ItemsDAO().editItems(id_items, name_items);
                if (edit == true)
                    response.sendRedirect("items");
            } else if (action != null && id_items != null && action.equals("hide")) {
                boolean hide = new ItemsDAO().hideItems(id_items);
                if (hide == true)
                    response.sendRedirect("items");
            } else if (action != null && id_items != null && action.equals("active")) {
                boolean active = new ItemsDAO().activeItems(id_items);
                if (active == true)
                    response.sendRedirect("items");
            } else if (action != null && id_items != null && action.equals("del")) {
                boolean del = new ItemsDAO().delItems(id_items);
                if (del == true)
                    response.sendRedirect("items");
            } else {
                response.setContentType("text/plain");
                response.getWriter().write("Else cuoi | action " + action);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
