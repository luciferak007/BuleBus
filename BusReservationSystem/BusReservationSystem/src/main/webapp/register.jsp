<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
            margin: 0;
            padding: 0;
        }
        .box {
            width: 400px;
            margin: 80px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #1e88e5;
            margin-bottom: 25px;
        }
        input {
            width: 100%;
            padding: 12px;
            margin: 12px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #1e88e5;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }
        button:hover {
            background: #1565c0;
        }
        a {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #1e88e5;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="box">
    <h2>Create Account</h2>

    <form action="register" method="post">
        <input type="text"     name="name"     placeholder="Full Name"     required>
        <input type="email"    name="email"    placeholder="Email"         required>
        <input type="text"     name="username" placeholder="Username"      required>
        <input type="password" name="password" placeholder="Password"      required>

        <input type="hidden" name="role" value="PASSENGER">

        <button type="submit">Register</button>
    </form>

    <a href="login.jsp">Already have an account? Login</a>
</div>

</body>
</html>