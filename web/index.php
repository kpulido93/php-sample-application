<?php
set_include_path(get_include_path() . PATH_SEPARATOR . '/var/www/html');
require_once __DIR__ . '/../src/Views/Layout.php';
require_once __DIR__ . '/../src/Views/Users/Listing.php';


$lastJoinedUsers = (require "dic/users.php")->getLastJoined();

switch (require "dic/negotiated_format.php") {
    case "text/html":
        (new Views\Layout(
            "Twitter - Newcomers", new Views\Users\Listing($lastJoinedUsers), true
        ))();
        exit;

    case "application/json":
        header("Content-Type: application/json");
        echo json_encode($lastJoinedUsers);
        exit;
}

http_response_code(406);
