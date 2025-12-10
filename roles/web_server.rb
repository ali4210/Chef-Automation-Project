name "web_server"
description "A role to configure Linux Web Servers"
# This role will trigger your 'my_webserver' cookbook
run_list "recipe[my_webserver]"
