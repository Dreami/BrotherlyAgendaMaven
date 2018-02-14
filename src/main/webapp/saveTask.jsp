<%@page contentType='text/html' pageEncoding='UTF-8'%>
 <!DOCTYPE html>
 <%
   HttpSession s = request.getSession();
   String name = ((String) s.getAttribute("taskName") == null?"":s.getAttribute("taskName").toString());
   String dueDate = ((String) s.getAttribute("taskDate") == null?"":s.getAttribute("taskDate").toString());
   String description = ((String) s.getAttribute("taskDescription") == null?"":s.getAttribute("taskDescription").toString());
 %>
 
 <html>
   <head>
       <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
       <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css'>
       <link rel='stylesheet' type='text/css' href='mainstyle.css'>
       <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
       <link rel="stylesheet" href="/resources/demos/style.css">
       <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
       <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
       <title>JSP Page</title>
   </head>
   <body>
       <h1><%=s.getAttribute("savetasktext")%></h1>
       
       <form id='saveTaskForm' name='taskForm' action='taskServlet' method='POST'>
           <div>
               <label>Tarea:</label>
               
               <input class='form-control' name='name' placeholder='Lavar la gata' value='<%=name%>'/>
           </div>
           
           <div>
               <label>Fin de plazo:</label>
               <input name='duedate' type="text" value='<%=dueDate%>' id="datepicker" class='form-control'>
           </div>
           <div>
               <label>Instrucciones:</label>
               <textarea class='form-control' name='description' rows='6' placeholder='De preferencia hacerlo con mucho aceite...'><%=description%></textarea>
           </div>
           <div><button name='savetask' class='btn btn-success' type='submit'>Guardar</button></div>    
       </form>
       
       <h3><div style="color:#FF0000;">${errorMessage}</div></h3>
       
   </body>
   
   <script>
       $( function() {
         $( "#datepicker" ).datepicker();
       } );
   </script>
 </html>