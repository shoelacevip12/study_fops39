CREATE USER 'repl_skv'@'%' IDENTIFIED WITH caching_sha2_password BY 'passskvdvs' REQUIRE NONE PASSWORD EXPIRE NEVER;
GRANT REPLICATION SLAVE ON *.* TO 'repl_skv'@'%';