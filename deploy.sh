#!/bin/bash

echo '================================='
echo '=== ARCHIVO DE IMPLEMENTACIÓN ==='
echo '================================='

echo 'Paso 1.- Crear Network para el Deploy'
docker network create devops-net

echo 'Paso 2.- Crear Directorios para Persistencia del Contenedor MongoDB'
mkdir -p ./database-data
mkdir -p ./database-key

echo 'Paso 3.- Crear Security Key File para MongoDB'
openssl rand -base64 756 > ./database-key/security.keyFile
chown 999:999 ./database-key/security.keyFile
chmod 0400 ./database-key/security.keyFile

echo 'Paso 4.- Deploy de Contenedor MongoDB'
docker run --name mongodb \
--network devops-net \
--restart=always \
-v ./database-data:/data/db \
-v ./database-key/security.keyFile:/etc/mongodb.key \
-p 27017:27017 -d \
mongo mongod --auth --keyFile=/etc/mongodb.key --bind_ip_all

echo 'Paso 5.- Acceder al CLI de MongoDB y Crear Usuario Administrador'
docker exec -it mongodb mongosh <<EOF
    use ${MONGO_ADMIN_DATABASE};
    db.createUser({
        user: "${MONGO_ADMIN_USER}", 
        pwd: "${MONGO_ADMIN_PASSWORD}", 
        roles:[{ 
            role: "root", 
            db: "${MONGO_ADMIN_DATABASE}"
        }]
    });
EOF

echo 'Paso 6.- Acceder al CLI de MongoDB como Administrador y Crear Entorno para la Aplicación'
docker exec -it mongodb mongosh -u ${MONGO_ADMIN_USER} -p ${MONGO_ADMIN_PASSWORD} <<EOF
    use ${MONGO_DATABASE};
    db.createUser({
        user: "${MONGO_USER}", 
        pwd: "${MONGO_PASSWORD}", 
        roles:[{ 
            role: "readWrite",
            db: "${MONGO_DATABASE}"
        }]
    });
    db.heroes.insertMany([
        {
            "superhero": "Batman",
            "publisher": "DC Comics",
            "alter_ego": "Bruce Wayne",
            "first_appearance": "Detective Comics #27",
            "characters": "Bruce Wayne"
        },
        {
            "superhero": "Superman",
            "publisher": "DC Comics",
            "alter_ego": "Kal-El",
            "first_appearance": "Action Comics #1",
            "characters": "Kal-El"
        },
        {
            "superhero": "Flash",
            "publisher": "DC Comics",
            "alter_ego": "Jay Garrick",
            "first_appearance": "Flash Comics #1",
            "characters": "Jay Garrick, Barry Allen, Wally West, Bart Allen"
        },
        {
            "superhero": "Green Lantern",
            "publisher": "DC Comics",
            "alter_ego": "Alan Scott",
            "first_appearance": "All-American Comics #16",
            "characters": "Alan Scott, Hal Jordan, Guy Gardner, John Stewart, Kyle Raynor, Jade, Sinestro, Simon Baz"
        },
        {
            "superhero": "Green Arrow",
            "publisher": "DC Comics",
            "alter_ego": "Oliver Queen",
            "first_appearance": "More Fun Comics #73",
            "characters": "Oliver Queen"
        },
        {
            "superhero": "Wonder Woman",
            "publisher": "DC Comics",
            "alter_ego": "Princess Diana",
            "first_appearance": "All Star Comics #8",
            "characters": "Princess Diana"
        },
        {
            "superhero": "Martian Manhunter",
            "publisher": "DC Comics",
            "alter_ego": "J'onn J'onzz",
            "first_appearance": "Detective Comics #225",
            "characters": "Martian Manhunter"
        },
        {
            "superhero": "Robin/Nightwing",
            "publisher": "DC Comics",
            "alter_ego": "Dick Grayson",
            "first_appearance": "Detective Comics #38",
            "characters": "Dick Grayson"
        },
        {
            "superhero": "Blue Beetle",
            "publisher": "DC Comics",
            "alter_ego": "Dan Garret",
            "first_appearance": "Mystery Men Comics #1",
            "characters": "Dan Garret, Ted Kord, Jaime Reyes"
        },
        {
            "superhero": "Black Canary",
            "publisher": "DC Comics",
            "alter_ego": "Dinah Drake",
            "first_appearance": "Flash Comics #86",
            "characters": "Dinah Drake, Dinah Lance"
        },
        {
            "superhero": "Spider Man",
            "publisher": "Marvel Comics",
            "alter_ego": "Peter Parker",
            "first_appearance": "Amazing Fantasy #15",
            "characters": "Peter Parker"
        },
        {
            "superhero": "Captain America",
            "publisher": "Marvel Comics",
            "alter_ego": "Steve Rogers",
            "first_appearance": "Captain America Comics #1",
            "characters": "Steve Rogers"
        },
        {
            "superhero": "Iron Man",
            "publisher": "Marvel Comics",
            "alter_ego": "Tony Stark",
            "first_appearance": "Tales of Suspense #39",
            "characters": "Tony Stark"
        },
        {
            "superhero": "Thor",
            "publisher": "Marvel Comics",
            "alter_ego": "Thor Odinson",
            "first_appearance": "Journey into Myster #83",
            "characters": "Thor Odinson"
        },
        {
            "superhero": "Hulk",
            "publisher": "Marvel Comics",
            "alter_ego": "Bruce Banner",
            "first_appearance": "The Incredible Hulk #1",
            "characters": "Bruce Banner"
        },
        {
            "superhero": "Wolverine",
            "publisher": "Marvel Comics",
            "alter_ego": "James Howlett",
            "first_appearance": "The Incredible Hulk #180",
            "characters": "James Howlett"
        },
        {
            "superhero": "Daredevil",
            "publisher": "Marvel Comics",
            "alter_ego": "Matthew Michael Murdock",
            "first_appearance": "Daredevil #1",
            "characters": "Matthew Michael Murdock"
        },
        {
            "superhero": "Hawkeye",
            "publisher": "Marvel Comics",
            "alter_ego": "Clinton Francis Barton",
            "first_appearance": "Tales of Suspense #57",
            "characters": "Clinton Francis Barton"
        },
        {
            "superhero": "Cyclops",
            "publisher": "Marvel Comics",
            "alter_ego": "Scott Summers",
            "first_appearance": "X-Men #1",
            "characters": "Scott Summers"
        },
        {
            "superhero": "Silver Surfer",
            "publisher": "Marvel Comics",
            "alter_ego": "Norrin Radd",
            "first_appearance": "The Fantastic Four #48",
            "characters": "Norrin Radd"
        }
    ]);
EOF