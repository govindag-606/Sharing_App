<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Topic Show</title>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

</head>

<body>

<div class="container">
    <br>
    <tmpl:/dashboard/searchTemplate subscriptions="${subscriptions}"/>
    <br>

    <div class="row d-flex justify-content-between">
        <div class="col-5">
            <br>
            <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">

                    <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                        <div class="col">Topic: "${subscription.topic.name}"</div>
                    </div>

                    <div class="row p-1" style="border-bottom: 2px solid black;">
                        <tmpl:/dashboard/subscriptionTemplate subscription="${subscription}"/>
                    </div>
                </div>
            </div>
            <br>
            <div class="row">
                <div class="col">
                    <div class="row border-bottom-0" style="border: 2px solid black; background-color: #DCDCDC;">
                        <div class="col">Users: "${subscription.topic.name}"</div>
                    </div>
                    <div id="users-container">
                        <input type="text" class="d-none topic_id" value="${subscription.topic.id}" name="topic_id">
                        %{--                        users will be added here--}%
                    </div>
                    <div id="pagination-container" class="m-1" style="border-bottom: 2px solid black;">
                        <ul class="pagination mb-1 ml-1">
                            <li class="page-item" id="prev-users"><a class="page-link" href="#">Prev</a></li>
                            <li class="page-item" id="start-users"><a class="page-link" href="#">Start</a></li>
                            <li class="page-item" id="next-users"><a class="page-link" href="#">Next</a></li>
                        </ul>
                    </div>
                    <script>
                        $(document).ready(function () {
                            let topic_id = $(".topic_id").val()
                            let currentPage = 1; // Track current page
                            // Load resources for initial page
                            loadUsers(currentPage);

                            // Function to load resources for a specific page via AJAX
                            function loadUsers(page) {
                                $.ajax({
                                    url: '/TopicShow/loadUsers',
                                    data: { page: page, topic_id: topic_id},
                                    success: function (data) {
                                        // Render the fetched resources using the GSP template and replace the content of resources-container
                                        $('#users-container').html(data);
                                        // Update pagination links
                                        updatePaginationLinks(page);
                                    }
                                });
                            }

                            // Function to update pagination links based on current page
                            function updatePaginationLinks(page) {

                                // Disable or enable "Prev" and "Start" links based on current page
                                $('#prev-users').toggleClass('disabled', page === 1);

                                // Update current page
                                currentPage = page;
                            }

                            // Event handler for pagination links
                            $(document).on('click', '#prev-users', function (e) {
                                e.preventDefault();
                                if (currentPage > 1) {
                                    currentPage--;
                                    loadUsers(currentPage);
                                }
                            });

                            $(document).on('click', '#start-users', function (e) {
                                e.preventDefault();
                                currentPage = 1;
                                loadUsers(currentPage);
                            });

                            $(document).on('click', '#next-users', function (e) {
                                e.preventDefault();
                                currentPage++;
                                loadUsers(currentPage);
                            });
                        });

                    </script>

                </div>
            </div>
        </div>

        <div class="col-6">
            <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
                <div class="col">
                    <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
%{--                        <div class="col">Posts: "${subscription.topic.name}"</div>--}%
                        <div class="col-10 d-flex align-items-center">Posts: "${subscription.topic.name}"</div>

                        <div class="col-2 p-1 d-flex justify-content-end">
                            <input type="text" value="${inboxSearch}" class="inboxSearch form-control form-control-sm" placeholder="Search">
                        </div>
                    </div>
                    <div id="inbox-container">
                        <input type="text" class="d-none topic_id" value="${subscription.topic.id}" name="topic_id">
                        %{--                        resources will be added here--}%
                    </div>
                    <div class="pagination-container m-1" style="border-bottom: 2px solid black;">
                        <ul class="pagination mb-1 ml-1">
                            <li id="prev-resources" class="page-item"><a class="page-link" href="#">Prev</a></li>
                            <li id="start-resources" class="page-item"><a class="page-link" href="#">Start</a></li>
                            <li id="next-resources" class="page-item"><a class="page-link" href="#">Next</a></li>
                        </ul>
                    </div>
                    <script>
                        $(document).ready(function () {

                            let topicID = $(".topic_id").val()

                            let currentPage = 1; // Track current page
                            // Load resources for initial page
                            loadPosts(currentPage);

                            // Function to load resources for a specific page via AJAX
                            function loadPosts(page) {
                                let inboxSearch = $(".inboxSearch").val()

                                $.ajax({
                                    url: '/TopicShow/loadPosts',
                                    data: { page: page, topic_id: topicID, inboxSearch: inboxSearch},
                                    success: function (data) {
                                        // Render the fetched resources using the GSP template and replace the content of resources-container
                                        $('#inbox-container').html(data);

                                        // Update pagination links
                                        updatePaginationLinks(page);
                                    }
                                });
                            }

                            // Function to update pagination links based on current page
                            function updatePaginationLinks(page) {

                                // Disable or enable "Prev" and "Start" links based on current page
                                $('#prev-resources').toggleClass('disabled', page === 1);

                                // Update current page
                                currentPage = page;
                            }

                            // Event handler for pagination links
                            $(document).on('click', '#prev-resources', function (e) {
                                e.preventDefault();
                                if (currentPage > 1) {
                                    currentPage--;
                                    loadPosts(currentPage);
                                }
                            });

                            $(document).on('click', '#start-resources', function (e) {
                                e.preventDefault();
                                currentPage = 1;
                                loadPosts(currentPage);
                            });

                            $(document).on('click', '#next-resources', function (e) {
                                e.preventDefault();
                                currentPage++;
                                loadPosts(currentPage);
                            });

                            // Event handler for input change on search input field
                            $('.inboxSearch').on('input', function() {
                                // Reload search results when the input value changes
                                currentPage = 1;
                                loadPosts(currentPage);
                            });
                        });

                    </script>
                </div>
            </div>
        </div>
    </div>
    <br>
</div>


<asset:javascript src="dashboard/dashboard.js"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
        crossorigin="anonymous"></script>
</body>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</html>