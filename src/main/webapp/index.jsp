<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.time.LocalDate"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.brotherlyagendamaven.Task"%>
<%@page contentType='text/html' pageEncoding='UTF-8'%>
<!DOCTYPE html>
<%
    HttpSession s = request.getSession();
    List<Task> taskList = new ArrayList<>();

    Cookie[] cookies = request.getCookies();
%>

<html>
    <head>
        <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css'>
        <link rel='stylesheet' type='text/css' href='mainstyle.css'>
        <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
        <title>Brotherly Web Agenda</title>
    </head>
    <body>
        <form name='mainForm' method='POST' action='taskServlet'>
            <div id='main'>
                <div id='greeting' class='col-md-6'>
                    <h1>Agenda</h1>
                </div>
                <div id='newTask' class='col-md-2 col-md-offset-4'>
                    <button name='createTask' type='submit' class='btn btn-default'>+ New task</button>
                </div>
            </div>

            <div id='statusText'>
                <h3>No borre los cookies del navegador, pl0x</h3>
            </div>
            <div id='taskList'>
                <%
                    if (cookies != null) {
                        for (Cookie c : cookies) {
                            if (c.getName().equals("task")) {
                                String jsonInString = c.getValue();
                                if (jsonInString != null || !jsonInString.isEmpty()) {
                                    response.addCookie(c);
                                    JSONObject jsonObj = new JSONObject("{taskList:" + jsonInString + "}");
                                    if (jsonObj.get("taskList") != null) {
                                        String n, dd, d, id;
                                        int day, month, year;
                                        JSONObject jsonObjTask;
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
                                        request.setAttribute("taskList", taskList);
                                    }
                                }
                            }
                        }

                        LocalDate today = LocalDate.now();
                        Collections.sort(taskList, new Comparator<Task>() {
                            public int compare(Task o1, Task o2) {
                                if (o1.getDueDate() == null || o2.getDueDate() == null) {
                                    return 0;
                                }
                                return o1.getDueDate().compareTo(o2.getDueDate());
                            }
                        });
                        if (!taskList.isEmpty()) {
                            for (Task t : taskList) {
                                if (today.compareTo(t.getDueDate()) > 0) {
                                    out.println("<h1>Te pasaste de la fecha: </h1>");
                                    out.println("<div class='task'>");
                                    out.println("<div ><h3>" + t.getName() + "</h3></div>");
                                    out.println("<p>Fecha de entrega: " + t.getDueDate() + "</p>");
                                    out.println("<p>" + t.getDescription() + "</p>");
                                    out.println("<div><button class='btn btn-default' name='editTask' value='" + t.getId() + "'>Editar</button><button class='btn btn-success' name='deleteTask' value='" + t.getId() + "'>Terminar</button</div>");
                                    out.println("</div>");
                                } else if (today.compareTo(t.getDueDate()) == 0) {
                                    out.println("<h1>Entregar para hoy: </h1>");
                                    out.println("<div class='task'>");
                                    out.println("<h3 class='col-md-10'>" + t.getName() + "</h3>");
                                    out.println("<p>Fecha de entrega: " + t.getDueDate() + "</p>");
                                    out.println("<p>" + t.getDescription() + "</p>");
                                    out.println("<div><button class='btn btn-default' name='editTask' value='" + t.getId() + "'>Editar</button><button class='btn btn-success' name='deleteTask' value='" + t.getId() + "'>Terminar</button</div>");
                                    out.println("</div>");
                                } else if (today.getMonth() == t.getDueDate().getMonth() && today.getYear() == t.getDueDate().getYear()) {
                                    out.println("<h1>Entregar para este mes: </h1>");
                                    out.println("<div class='task'>");
                                    out.println("<h3>" + t.getName() + "</h3>");
                                    out.println("<p>Fecha de entrega: " + t.getDueDate() + "</p>");
                                    out.println("<p>" + t.getDescription() + "</p>");
                                    out.println("<div><button class='btn btn-default' name='editTask' value='" + t.getId() + "'>Editar</button><button class='btn btn-success' name='deleteTask' value='" + t.getId() + "'>Terminar</button</div>");
                                    out.println("</div>");
                                } else if (today.getYear() == t.getDueDate().getYear()) {
                                    out.println("<h1>Entregar para este año: </h1>");
                                    out.println("<div class='task'>");
                                    out.println("<h3>" + t.getName() + "</h3>");
                                    out.println("<p>Fecha de entrega: " + t.getDueDate() + "</p>");
                                    out.println("<p>" + t.getDescription() + "</p>");
                                    out.println("<div><button class='btn btn-default' name='editTask' value='" + t.getId() + "'>Editar</button><button class='btn btn-success' name='deleteTask' value='" + t.getId() + "'>Terminar</button</div>");
                                    out.println("</div>");
                                } else if (today.getYear() < t.getDueDate().getYear()) {
                                    out.println("<h1>Entregar para un lejano futuro: </h1>");
                                    out.println("<div class='task'>");
                                    out.println("<h3>" + t.getName() + "</h3>");
                                    out.println("<p>Fecha de entrega: " + t.getDueDate() + "</p>");
                                    out.println("<div><button class='btn btn-default' name='editTask' value='" + t.getId() + "'>Editar</button><button class='btn btn-success' name='deleteTask' value='" + t.getId() + "'>Terminar</button</div>");
                                    out.println("<p>" + t.getDescription() + "</p>");
                                    out.println("</div>");
                                }
                            }
                        }
                    }
                %>
            </div>
        </form>
    </body>
</html>