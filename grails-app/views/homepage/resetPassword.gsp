<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Forget Password</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha384-vtXRMe3mGCbOeY7l30aIg8H9p3GdeSe4IFlP6G8JMa7o7lXvnz3GFKzPxzJdPfGK" crossorigin="anonymous"></script>

    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
    <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
</head>
<style>
.form-gap {
    padding-top: 70px;
}
</style>
<body>

<g:if test="${flash.success || flash.failure}">
    <div id="alertMessage" class="alert ${flash.failure? 'alert-danger' : 'alert-success'}">
        ${flash.success?: flash.failure}
    </div>
    <script>
        // Automatically hide the alert after 1.5 seconds
        setTimeout(function() {
            $('#alertMessage').fadeOut('slow'); }, 1500);
    </script>
</g:if>


<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
<div class="form-gap"></div>
<div class="container">
    <div class="row">
        <div class="col-md-4 col-md-offset-4">
            <div class="panel panel-default">
                <div class="panel-body">
                    <div class="text-center">
                        <h3><i class="fa fa-lock fa-4x"></i></h3>
                        <h2 class="text-center">Forgot Password?</h2>
                        <p>You can reset your password here.</p>
                        <div class="panel-body">
                            <g:form controller="authentication" action="ResetPass">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="glyphicon glyphicon-envelope color-blue"></i></span>
                                        <input id="email" name="email" placeholder="email address" class="form-control" type="email">
                                    </div>
                                    <div class="input-group"  style="margin-bottom: 10px; margin-top: 10px">
                                        <span class="input-group-addon"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-key-fill" viewBox="0 0 16 16">
                                            <path d="M3.5 11.5a3.5 3.5 0 1 1 3.163-5H14L15.5 8 14 9.5l-1-1-1 1-1-1-1 1-1-1-1 1H6.663a3.5 3.5 0 0 1-3.163 2M2.5 9a1 1 0 1 0 0-2 1 1 0 0 0 0 2"/>
                                        </svg></span>
                                        <input id="pass" name="password" placeholder="Your Password.." class="form-control"  type="password">
                                    </div>

                                    <div class="input-group">
                                        <span class="input-group-addon"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-key-fill" viewBox="0 0 16 16">
                                            <path d="M3.5 11.5a3.5 3.5 0 1 1 3.163-5H14L15.5 8 14 9.5l-1-1-1 1-1-1-1 1-1-1-1 1H6.663a3.5 3.5 0 0 1-3.163 2M2.5 9a1 1 0 1 0 0-2 1 1 0 0 0 0 2"/>
                                        </svg></span>
                                        <input id="cpass" name="Confirm_Password" placeholder="Your Confirm Password.." class="form-control"  type="email">
                                        <p id="passwordError" style="color: red; display: none;">Passwords do not match.</p>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <button name="recover-submit" class="btn btn-lg btn-primary btn-block" value="Reset Password" type="submit">Reset Password</button>
                                </div>
                                <input type="hidden" class="hide" name="token" id="token" value="">
                            </g:form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>

<script>


    const passInput = document.getElementById('pass');
    const cpassInput = document.getElementById('cpass');
    const updateButton = document.getElementById('updateButton');
    const passwordForm = document.getElementById('passwordForm');
    const passwordError = document.getElementById('passwordError');

    // Function to check if passwords match
    function checkPasswordMatch() {
        if (passInput.value !== cpassInput.value) {
            passwordError.style.display = 'block';
            updateButton.disabled = true;
        } else {
            passwordError.style.display = 'none';
            updateButton.disabled = false;
        }
    }

    // Add event listener to confirm password input
    cpassInput.addEventListener('input', checkPasswordMatch);

    // Add event listener to Update button
    updateButton.addEventListener('click', function() {
        if (passInput.value === cpassInput.value) {
            // Submit the form if passwords match
            passwordForm.submit();
        }
    });


</script >
</html>