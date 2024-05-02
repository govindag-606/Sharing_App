<%@ page import="test.Subscription" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Search</title>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

</head>


<div class="container">
    <br>
<tmpl:/dashboard/searchTemplate subscriptions="${subscriptions}"/>
<br>

<div class="row d-flex justify-content-between">
    <div class="col-5">
        <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
            <div class="col">
                <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                    <div class="col">Trending Topics</div>
                </div>
                <g:each in="${trendTopicSubs}" var="subscription">
                    <g:if test="${subscription.topic.createdBy.username == session.user.username || (subscription.topic.visibility.toString()).equals("Public")}">
                        <div class="row p-0" style="border-bottom: 2px solid black;">
                            <tmpl:/dashboard/subscriptionTemplate subscription="${subscription}"/>
                        </div>
                    </g:if>
                </g:each>
            </div>
        </div>
        <br>

        <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
            <div class="col">
                <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                    <div class="col">Top Posts</div>
                </div>
                <g:each in="${topPosts}" var="resource">
                    <div class="row p-1" style="border-bottom: 2px solid black;">
                        <tmpl:/topicShow/inboxCardPostTemplate resource="${resource}"/>
                    </div>
                </g:each>
            </div>
        </div>
    </div>

    <div class="col-6">
        <div class="row border-bottom-0" style="border: 2px solid black; border-radius: 6px;">
            <div class="col">
                <div class="row" style="border-bottom: 2px solid black; background-color: #DCDCDC;">
                    <div class="col">Search for "${key}"</div>
                </div>
                <div id="search-container">
                    <input type="text" class="d-none key" value="${key}" name="key">
                    %{--                        users will be added here--}%
                </div>

                <div id="pagination-container" class="m-1" style="border-bottom: 2px solid black;">
                    <ul class="pagination mb-1 ml-1">
                        <li class="page-item" id="prev-search"><a class="page-link" href="#">Prev</a></li>
                        <li class="page-item" id="start-search"><a class="page-link" href="#">Start</a></li>
                        <li class="page-item" id="next-search"><a class="page-link" href="#">Next</a></li>
                    </ul>
                </div>

                <script>
                    $(document).ready(function () {
                        let key = $(".key").val()

                        let currentPage = 1; // Track current page
                        // Load resources for initial page
                        loadSearch(currentPage);

                        // Function to load resources for a specific page via AJAX
                        function loadSearch(page) {
                            $.ajax({
                                url: '/Search/loadSearch',
                                data: {page: page, key: key},
                                success: function (data) {
                                    // Render the fetched resources using the GSP template and replace the content of resources-container
                                    $('#search-container').html(data);

                                    // Update pagination links
                                    updatePaginationLinks(page);
                                }
                            });
                        }

                        // Function to update pagination links based on current page
                        function updatePaginationLinks(page) {

                            // Disable or enable "Prev" and "Start" links based on current page
                            $('#prev-search').toggleClass('disabled', page === 1);

                            // Update current page
                            currentPage = page;
                        }

                        // Event handler for pagination links
                        $(document).on('click', '#prev-search', function (e) {
                            e.preventDefault();
                            if (currentPage > 1) {
                                currentPage--;
                                loadSearch(currentPage);
                            }
                        });

                        $(document).on('click', '#start-search', function (e) {
                            e.preventDefault();
                            currentPage = 1;
                            loadSearch(currentPage);
                        });

                        $(document).on('click', '#next-search', function (e) {
                            e.preventDefault();
                            currentPage++;
                            // console.log("Next clicked. Current page:", currentPage);
                            loadSearch(currentPage);
                        });
                    });

                </script>
            </div>
        </div>
    </div>
</div>
</div>

<asset:javascript src="dashboard/dashboard.js"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
        crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</body>
</html>
