<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>HomePage</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

</head>

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

<div class="container">

    <br>

    <!-- LinkShare Box -->
    <div class="row" style="border: 2px solid black; border-radius: 6px;">
        <div class="navbar-brand col-9 p-2 d-flex align-items-center">LinkSharing</div>
    </div>

    <br>


    <div class="row d-flex justify-content-between">

        <div class="col-6">

            <!-- RecentShare Box -->
            <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row" style="border-bottom: 2px solid black; background-color: #dcdcdc;">
                        <div class="col">Recent shares</div>
                    </div>

                    <g:each in="${recents}" var="resource">
                        <div class="row p-1" style="border-bottom: 2px solid black;">
                            <tmpl:/topicShow/inboxCardPostTemplate resource="${resource}"/>
                        </div>
                    </g:each>
                </div>
            </div>

            <br>

            <!-- TopPosts Box -->
            <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                        <div class="col-10 d-flex align-items-center">Top posts</div>

                        <div class="col-2 p-1 form-group">
                            <g:form controller="homepage" action="index">
                                <g:select name="timePeriod" class="form-select form-select-sm"
                                          from="${['today', 'week', 'month', 'year']}"
                                          value="${timePeriod}" onchange="this.form.submit()"/>
                            </g:form>
                        </div>
                    </div>

                    <g:each in="${topPosts}" var="resource">
                        <div class="row p-1" style="border-bottom: 2px solid black;">
                            <tmpl:/topicShow/inboxCardPostTemplate resource="${resource}"/>
                        </div>
                    </g:each>
                </div>
            </div>

        </div>

        <div class="col-5">

            <!-- LogIn Box -->
            <div class="row" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                        <div class="col">Login</div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <div class="container mt-3">
                                <g:form controller="authentication" action="login">
                                    <div class="row mb-3">
                                        <label for="emailOrUsername"
                                               class="col-4 col-form-label">Email/Username:</label>

                                        <div class="col-8">
                                            <g:textField id="emailOrUsername" class="form-control"
                                                         name="emailOrUsername" required=""/>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <label for="password1" class="col-4 col-form-label">Password:</label>

                                        <div class="col-8">
                                            <g:passwordField class="form-control" name="password1" required=""/>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-6 text-start">
                                            <g:link controller="authentication" action="forgetPassword">Forgot password?</g:link>
                                        </div>

                                        <div class="col-6 text-end">
                                            <g:submitButton class="btn btn-primary" name="login" value="login"/>
                                        </div>
                                    </div>
                                </g:form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <br>

            <!-- Register Box -->
            <div class="row" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                        <div class="col">Register</div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <div class="container mt-2">
                                <g:form class="login-form" enctype="multipart/form-data" id="registerForm"
                                        controller="authentication" action="register"
                                        onsubmit="return validatePassword()">

                                    <div class="mb-2 row">
                                        <label for="firstName" class="col-4 col-form-label">First Name:</label>

                                        <div class="col-8">
                                            <input type="text" id="firstName" class="form-control" name="firstName"
                                                   required>
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label for="lastName" class="col-4 col-form-label">Last Name:</label>

                                        <div class="col-8">
                                            <input type="text" id="lastName" class="form-control" name="lastName"
                                                   required>
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label for="email" class="col-4 col-form-label">Email:</label>

                                        <div class="col-8">
                                            <input type="email" id="email" class="form-control" name="email" required>
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label for="username" class="col-4 col-form-label">Username:</label>

                                        <div class="col-8">
                                            <input type="text" id="username" class="form-control" name="username"
                                                   required>
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label for="password" class="col-4 col-form-label">Password:</label>

                                        <div class="col-8">
                                            <input type="password" id="password" class="form-control" name="password" required>

                                            <div id="passwordError" class="invalid-feedback"></div> <!-- Error message container -->
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label for="confirmPassword" class="col-4 col-form-label">Confirm Password:</label>

                                        <div class="col-8">
                                            <input type="password" id="confirmPassword" class="form-control" name="confirmPassword" required>

                                            <div id="confirmPasswordError" class="invalid-feedback"></div> <!-- Error message container -->
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label class="col-4 col-form-label">Photo:</label>

                                        <div class="col-8">
                                            <div class="input-group">
                                                <input type="text" class="form-control" id="file-selected"
                                                       placeholder="Choose file">
                                                <label class="input-group-text" for="photo">Browse</label>
                                                <input type="file" id="photo" class="form-control d-none" name="photo"
                                                       onchange="validatePhoto(this)">
                                            </div>

                                            <div id="error-message" class="invalid-feedback"
                                                 style="display: none;">Invalid file type. Please choose an image file.</div>

                                        </div>

                                    </div>

                                    <div class="mb-2 row">
                                        <div class="col text-end">
                                            <button type="submit" class="btn btn-primary">
                                                Register
                                            </button>
                                        </div>
                                    </div>
                                </g:form>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div>
</div>


<asset:javascript src="dashboard/dashboard.js"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</body>
</html>