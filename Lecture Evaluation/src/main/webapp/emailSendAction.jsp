<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "javax.mail.*" %>
<%@ page import= "java.util.Properties" %>
<%@ page import= "user.UserDAO" %>
<%@ page import= "util.SHA256" %>
<%@ page import= "util.Gmail" %>
<%@ page import= "java.io.PrintWriter" %>

<%
  UserDAO userDAO = new UserDAO();
  String userID=null;
  if(session.getAttribute("userID") != null){
	  userID = (String) session.getAttribute("userID");
  }
  if(userID == null){
	  PrintWriter script = response.getWriter();   
      script.print("<script>");
      script.print("alert('로그인을 해주세요.');");
      script.print("location.href = 'userLogin.jsp'");
      script.print("</script>");
      script.close(); 
  }
  
  boolean emailChecked = userDAO.getUserEmailCheked(userID);
  if(emailChecked == true){
	  PrintWriter script = response.getWriter();   
      script.print("<script>");
      script.print("alert('이미 존재하는 아이디입니다.');");
      script.print("location.href = 'index.jsp'");
      script.print("</script>");
      script.close();    
  }
  
  String host ="http://localhost:8099/Lecture_Evaluation/";
  String from ="shdlfgh147@gmail.com";
  String to = userDAO.getUserEmail(userID);
  String subject = "강의 평가를 위한 이메일 인증 메일입니다";
  String content = "다음 링크에 접속하여 이메일 인증을 진행하세요."+
   "<a href ='" + host + "emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'>이메일인증하기</a>";
  
   Properties p = new Properties();
   p.put("mail.smtp.host", "smtp.gmail.com");
	p.put("mail.smtp.port", "465");
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");


          //p.put("mail.smtp.starttls.required", "true");

	p.put("mail.smtp.ssl.protocols", "TLSv1.2");
	
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
   
   try{
	   Authenticator auth = new Gmail();
	   Session ses = Session.getInstance(p,auth); 
	   ses.setDebug(true);
	   MimeMessage msg = new MimeMessage(ses);
	   msg.setSubject(subject);
	   Address fromAddr = new InternetAddress(from);
	   msg.setFrom(fromAddr);
	   Address toAddr = new InternetAddress(to);
	   msg.addRecipient(Message.RecipientType.TO,toAddr);
	   msg.setContent(content,"text/html;charset=utf-8");
	   Transport.send(msg);
	   
   }catch(Exception e){
	   e.printStackTrace();
	   PrintWriter script = response.getWriter();   
	      script.print("<script>");
	      script.print("alert('오류가 발생했습니다.');");
	      script.print("history.back();");
	      script.print("</script>");
	      script.close();
	      return;
   }
   %>
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name= "viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no">
<title>강의평가 웹 사이트</title>
<!-- 부트스트랩 css 추가하기 -->
<link rel="stylesheet" href="./css/bootstrap.min.css">
<!-- 커스텀 css 추가하기 -->
<link rel="stylesheet" href="./css/custom.css">
</head>
<body>

      <nav class="navbar navbar-expand-lg navbar-light bg-light">
      <a class="navbar-brand" href="index.jsp">강의평가 웹 사이트</a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div id="navbar" class="collapse navbar-collapse">
        <ul class="navbar-nav mr-auto">
            <li class="navbar-item active">
                <a class="nav-link" href="index.jsp">메인</a>
            </li>
            <li class="navbar-item dropdown">
                <a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
                   회원관리
                </a>
                <div class="dropdown-menu" aria-labelledby="dropdown">
 <%
   if(userID==null){	    
 %>
                    <a class="dropdown-item" href="userLogin.jsp">로그인</a>
                    <a class="dropdown-item" href="userjoin.jsp">회원가입</a>
<% 
   }else {
%>                    
                    <a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
<%
   }
%>                    
                </div>
            </li>
        </ul>
       <form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
           <input type="text" name="search" class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-label="search">
           <button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>        
        </form>
      </div>
   </nav>
   <section class="container mt-3" style="max-width: 560px;">
     <div class="alert alert-success mt-4" role= "alert">
         이메일 주소 인증 메일이 전송 되었습니다. 회원가입시 인증을 해주세요
     </div>   
       
   </section>
   
   
   
   <footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
       Copyright &copy; 2022 노일호 All Rights Reserved.
   </footer>
   
  <script src="./js/jquery.min.js"></script>
  <script src="./js/popper.js"></script>
  <script src="./js/bootstrap.min.js"></script>
</body>
</html>
