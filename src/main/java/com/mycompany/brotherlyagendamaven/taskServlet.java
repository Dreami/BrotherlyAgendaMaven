package com.mycompany.brotherlyagendamaven;

import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.Iterator;
import java.util.List;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

public class taskServlet extends HttpServlet {

    private String datePattern = "MM/dd/yyyy";
    private List<Task> taskList = new ArrayList<Task>();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession s = request.getSession();
        Cookie[] tasksInCookies = request.getCookies();

        String n, dd, d, id;
        JSONObject jsonObjTask;

        for (Cookie c : tasksInCookies) {
            if (c.getName().equals("task")) {
                String jsonInString = c.getValue();
                if (jsonInString == null || jsonInString.isEmpty()) {
                    JSONObject jsonObj = new JSONObject("{taskList:" + jsonInString + "}");
                    if (jsonObj.get("taskList") != null) {
                        int day, month, year;
                        JSONArray jsonArr = jsonObj.getJSONArray("taskList");
                        for (int i = 0; i < jsonArr.length(); i++) {
                            jsonObjTask = jsonArr.getJSONObject(i);
                            id = jsonObjTask.getString("id");
                            n = jsonObjTask.getString("name");
                            d = jsonObjTask.getString("description");
                            jsonObjTask = (JSONObject) jsonObjTask.get("dueDate");
                            year = jsonObjTask.getInt("year");
                            day = jsonObjTask.getInt("dayOfMonth");
                            month = jsonObjTask.getInt("monthValue");
                            dd = month + "/" + day + "/" + year;
                            taskList.add(new Task(n, d, dd, id));
                        }
                    }
                }
            }
        }

        if (request.getParameter("createTask") != null) {
            s.setAttribute("savetasktext", "Crear nueva tarea");
            response.sendRedirect("saveTask.jsp");
        } else if (request.getParameter("editTask") != null) {
            s.setAttribute("savetasktext", "Modificar tarea");
            String taskId = request.getParameter("editTask");

            for (Task t : taskList) {
                if (t.getId().equals(taskId)) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");
                    String editDueDate = t.getDueDate().format(formatter);
                    s.setAttribute("taskName", t.getName());
                    s.setAttribute("taskDate", editDueDate);
                    s.setAttribute("taskDescription", t.getDescription());
                }
            }
            removeTask(taskId);
            response.sendRedirect("saveTask.jsp");

        } else if (request.getParameter("deleteTask") != null) {
            String taskId = request.getParameter("deleteTask");
            removeTask(taskId);
            response.addCookie(getTaskListCookie());
            response.sendRedirect("index.jsp");
        } else if (request.getParameter("savetask") != null) {
            s.removeAttribute("taskName");
            s.removeAttribute("taskDate");
            s.removeAttribute("taskDescription");
            
            String name, dueDateText, description;
            name = request.getParameter("name");
            dueDateText = request.getParameter("duedate");
            description = request.getParameter("description");
            Pattern p = Pattern.compile("([0-9]{2})/([0-9]{2})/([0-9]{4})");
            Matcher m = p.matcher(dueDateText);

            if (m.matches()) {

                String[] dateArray = dueDateText.split("/");
                int month, day;
                month = Integer.parseInt(dateArray[0]);
                day = Integer.parseInt(dateArray[1]);

                if (!(month > 0 && month < 13)) {
                    attachErrorMsg(request, response, "Los meses deben de estar dentro de un rango de 1 y 12.");
                }

                if (!(day > 0 && day < 32)) {
                    attachErrorMsg(request, response, "Los días deben de ser entre 1 y 31.");
                }

            } else {
                attachErrorMsg(request, response, "El formato de la fecha es incorrecto. Debe seguir 'MM/dd/yyyy'.");
            }

            if (name.isEmpty()) {
                attachErrorMsg(request, response, "Es obligatorio llenar el campo de tarea.");
            }

            Task task = new Task(name, description, dueDateText);
            taskList.add(task);
            String jsonTask = JsonUtil.toJsonString(taskList);

            response.addCookie(getTaskListCookie());
            request.getSession().removeAttribute("errorMessage");
            response.sendRedirect("index.jsp");
        }
    }

    private Cookie getTaskListCookie() {
        String jsonTask = JsonUtil.toJsonString(taskList);
        Cookie cookie = new Cookie("task", jsonTask);
        cookie.setMaxAge(60 * 60 * 24 * 365 * 10);
        return cookie;
    }

    private void removeTask(String taskId) {
        for (Iterator<Task> iterator = taskList.iterator(); iterator.hasNext();) {
            if (iterator.next().getId().equals(taskId)) {
                iterator.remove();
            }
        }
    }

    private void attachErrorMsg(HttpServletRequest request, HttpServletResponse response, String errMsg)
            throws ServletException, IOException {
        request.getSession().setAttribute("errorMessage", errMsg);
        response.sendRedirect(request.getHeader("index.jsp"));
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
