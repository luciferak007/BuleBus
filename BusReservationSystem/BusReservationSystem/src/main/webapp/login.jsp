<!DOCTYPE html>
<html>
<head>
    <title>User Login</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>

        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #4e73df, #1cc88a);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .box {
            width: 350px;
            background: white;
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
            animation: fadeIn 0.6s ease-in-out;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

       input {
    width: 90%;
    padding: 12px;
    margin: 10px auto;
    display: block;
    border-radius: 8px;
    border: 1px solid #ccc;
}


        input:focus {
            border-color: #4e73df;
            outline: none;
            box-shadow: 0 0 5px rgba(78,115,223,0.4);
        }

        button {
            width: 100%;
            padding: 12px;
            background: #4e73df;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: 0.3s;
        }

        button:hover {
            background: #2e59d9;
            transform: translateY(-2px);
        }

        .link {
            display: block;
            text-align: center;
            margin-top: 15px;
            text-decoration: none;
            color: #4e73df;
            font-weight: 500;
        }

        .link:hover {
            text-decoration: underline;
        }

        .error {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

    </style>
</head>

<body>

<div class="box">
    <h2>User Login</h2>

    <!-- Error message (optional JSP dynamic message) -->
    <% if(request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>

  <form action="login" method="post">
    <input type="text" name="email" placeholder="Enter Email" required>
    <input type="password" name="password" placeholder="Enter Password" required>
    <button type="submit">Login</button>
</form>

    <a href="register.jsp" class="link">New user? Create account</a>
</div>

</body>
</html>
