<?php

// Start session
session_start();

// Include database connection
include('db.php');

// Check if form is submitted
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $usernameOrEmail = $_POST['username'];
    $password = $_POST['password'];

    // Prepare a query to find the user by email or username
    $query = "SELECT * FROM users WHERE email = ? OR username = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ss", $usernameOrEmail, $usernameOrEmail);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows == 1) {
        // Fetch user data
        $user = $result->fetch_assoc();

        // Verify password
        if (password_verify($password, $user['password'])) {
            // Login successful, set session variables
            $_SESSION['user'] = $user['username'];
            $_SESSION['email'] = $user['email'];

            // Redirect to home page
            header("Location: home.php");
            exit();
        } else {
            $error = "Invalid password. Please try again.";
        }
    } else {
        $error = "Invalid email or username. Please try again.";
    }
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        
        body {
            background-image: url('https://t4.ftcdn.net/jpg/10/94/32/81/360_F_1094328179_fgrP3lNkYnM9ytX5HFRjdHcPM5X3lN7M.jpg');
            background-size: cover; /* Make the background image cover the entire screen */
            background-position: center; /* Center the image */
            background-repeat: no-repeat; /* Do not repeat the image */
            height: 90vh; /* Full height of the viewport */
            margin: 0;
        }
        
        .card {
            border: none;
        }

        .password-toggle {
            position: relative;
        }

        .password-toggle .toggle-icon {
            position: absolute;
            top: 50%;
            right: 10px;
            transform: translateY(-50%);
            cursor: pointer;
        }
        h2 {
            font-size: 3rem;
            color: rgb(9, 21, 90);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="text-center mt-5">Login</h2>
        <div class="row justify-content-center mt-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <?php if (isset($error)): ?>
                            <div class="alert alert-danger"><?php echo $error; ?></div>
                        <?php endif; ?>
                        <form action="login.php" method="POST">
                            <div class="form-group">
                                <label for="username">Username or Email</label>
                                <input type="text" name="username" id="username" class="form-control" required>
                            </div>
                            <div class="form-group password-toggle">
                                <label for="password">Password</label>
                                <input type="password" name="password" id="password" class="form-control" required>
                                <span class="toggle-icon" onclick="togglePassword()">👁️</span>
                            </div>
                            <button type="submit" class="btn btn-primary btn-block">Log In</button>
                        </form>
                        <p class="text-center mt-3">
                            Don't have an account? <a href="register.php">Register here</a>.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function togglePassword() {
            const passwordField = document.getElementById("password");
            const toggleIcon = document.querySelector(".toggle-icon");

            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleIcon.textContent = "🙈"; // Change icon to "hide"
            } else {
                passwordField.type = "password";
                toggleIcon.textContent = "👁️"; // Change icon to "show"
            }
        }
    </script>
</body>
</html>
