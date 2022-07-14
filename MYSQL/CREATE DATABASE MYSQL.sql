CREATE DATABASE Signlator;
USE Signlator;
create table anuncios
(
    id          int auto_increment
        primary key,
    titulo      varchar(50) not null,
    descripcion text        not null
);

create table archivos
(
    id             int auto_increment
        primary key,
    descripcion    text        not null,
    formato        varchar(50) not null,
    duracion       time        not null,
    enlace_archivo varchar(50) not null
);

create table categorias
(
    id          int auto_increment
        primary key,
    titulo      varchar(50) not null,
    descripcion text        not null
);

create table frases
(
    id          int auto_increment
        primary key,
    descripcion text        not null,
    titulo      varchar(50) not null
);

create table gestos
(
    id          int auto_increment
        primary key,
    nombre      varchar(50) not null,
    descripcion text        not null,
    imagen      blob        null
);

create table lenguajes
(
    id          int auto_increment
        primary key,
    descripcion text not null
);

create table ideas
(
    id            int auto_increment
        primary key,
    descripcion   text not null,
    categorias_id int  not null,
    gestos_id     int  not null,
    frases_id     int  not null,
    lenguajes_id  int  not null,
    constraint ideas_categorias
        foreign key (categorias_id) references categorias (id),
    constraint ideas_frases
        foreign key (frases_id) references frases (id),
    constraint ideas_gestos
        foreign key (gestos_id) references gestos (id),
    constraint ideas_lenguajes
        foreign key (lenguajes_id) references lenguajes (id)
);

create table mensajes
(
    id      int auto_increment
        primary key,
    formato varchar(50) not null
);

create table niveles
(
    id          int auto_increment
        primary key,
    nombre      varchar(50) not null,
    descripcion text        not null,
    objetivo    text        not null
);

create table cursos
(
    id           int auto_increment
        primary key,
    nombre       varchar(50) not null,
    descripcion  text        not null,
    fecha_inicio date        not null,
    niveles_id   int         not null,
    constraint cursos_niveles
        foreign key (niveles_id) references niveles (id)
);

create table anunciosxcursos
(
    cursos_id     int  not null,
    anuncios_id   int  not null,
    fecha_anuncio date not null,
    primary key (cursos_id, anuncios_id),
    constraint anunciosxcursos_anuncios
        foreign key (anuncios_id) references anuncios (id),
    constraint anunciosxcursos_cursos
        foreign key (cursos_id) references cursos (id)
);

create table paises
(
    id     int auto_increment
        primary key,
    nombre varchar(50) not null
);

create table ciudades
(
    id        int auto_increment
        primary key,
    nombre    varchar(50) not null,
    paises_id int         not null,
    constraint ciudades_paises
        foreign key (paises_id) references paises (id)
);

create table distritos
(
    id          int auto_increment
        primary key,
    nombre      varchar(50) not null,
    ciudades_id int         not null,
    constraint distritos_ciudades
        foreign key (ciudades_id) references ciudades (id)
);

create table parentescos
(
    id          int auto_increment
        primary key,
    nombre      varchar(50) not null,
    descripcion text        not null
);

create table apoderados
(
    id             int auto_increment
        primary key,
    nombre         varchar(50) not null,
    apellido       varchar(50) not null,
    parentescos_id int         not null,
    constraint apoderados_parentescos
        foreign key (parentescos_id) references parentescos (id)
);

create table segmentos
(
    id          int auto_increment
        primary key,
    descripcion text not null
);

create table traducciones
(
    id           int auto_increment
        primary key,
    descripcion  text not null,
    lenguajes_id int  not null,
    constraint traducciones_lenguajes
        foreign key (lenguajes_id) references lenguajes (id)
);

create table unidades
(
    id          int auto_increment
        primary key,
    descripcion text         not null,
    objetivo    varchar(100) null,
    cursos_id   int          not null,
    constraint unidades_cursos
        foreign key (cursos_id) references cursos (id)
);

create table temas
(
    id          int auto_increment
        primary key,
    descripcion text not null,
    unidades_id int  not null,
    constraint temas_unidades
        foreign key (unidades_id) references unidades (id)
);

create table examenes
(
    id           int auto_increment
        primary key,
    descripcion  text       not null,
    peso         decimal(2) not null,
    fecha_inicio date       not null,
    fecha_fin    date       not null,
    temas_id     int        not null,
    constraint examenes_temas
        foreign key (temas_id) references temas (id)
);

create table recursos
(
    id          int auto_increment
        primary key,
    descripcion text        not null,
    titulo      varchar(50) not null,
    temas_id    int         not null,
    archivos_id int         not null,
    constraint recursos_archivos
        foreign key (archivos_id) references archivos (id),
    constraint recursos_temas
        foreign key (temas_id) references temas (id)
);

create table usuarios
(
    id            int auto_increment
        primary key,
    nombre        varchar(50) not null,
    apellido      varchar(50) not null,
    sexo          varchar(10) not null,
    correo        varchar(50) not null,
    telefono      int         not null,
    dni           char(8)     not null,
    apoderados_id int         null,
    segmentos_id  int         not null,
    distritos_id  int         not null,
    constraint usuarios_apoderados
        foreign key (apoderados_id) references apoderados (id),
    constraint usuarios_distritos
        foreign key (distritos_id) references distritos (id),
    constraint usuarios_segmentos
        foreign key (segmentos_id) references segmentos (id)
);

create table cursosxusuarios
(
    usuarios_id        int         not null,
    cursos_id          int         not null,
    progreso           varchar(50) not null,
    fecha_inscripcion  date        not null,
    fecha_finalizacion date        null,
    estado             varchar(50) not null,
    primary key (usuarios_id, cursos_id),
    constraint cursosxusuarios_cursos
        foreign key (cursos_id) references cursos (id),
    constraint cursosxusuarios_usuarios
        foreign key (usuarios_id) references usuarios (id)
);

create table traduccionesxusuarios
(
    usuarios_id      int  not null,
    traducciones_id  int  not null,
    fecha_traduccion date not null,
    mensajes_id      int  not null,
    primary key (usuarios_id, traducciones_id),
    constraint traduccionesxusuarios_mensajes
        foreign key (mensajes_id) references mensajes (id),
    constraint traduccionesxusuarios_traducciones
        foreign key (traducciones_id) references traducciones (id),
    constraint traduccionesxusuarios_usuarios
        foreign key (usuarios_id) references usuarios (id)
);

create definer = root@`%` view v_total_traducciones_each_user as
select `Signlator`.`usuarios`.`nombre` AS `Usuario`, count(`t`.`traducciones_id`) AS `Cant_Traducciones`
from (`Signlator`.`usuarios`
         join `Signlator`.`traduccionesxusuarios` `t` on ((`Signlator`.`usuarios`.`id` = `t`.`usuarios_id`)))
group by `Signlator`.`usuarios`.`nombre`;

create definer = root@`%` view v_total_usuarios_per_country as
select count(`u`.`id`) AS `Cantidad`, `p`.`nombre` AS `Pais`
from (((`Signlator`.`usuarios` `u` join `Signlator`.`distritos` `d` on ((`u`.`distritos_id` = `d`.`id`))) join `Signlator`.`ciudades` `c` on ((`d`.`ciudades_id` = `c`.`id`)))
         join `Signlator`.`paises` `p` on ((`c`.`paises_id` = `p`.`id`)))
group by `p`.`nombre`;

create definer = root@`%` view v_usuarios_ciudad_per_country as
select `c`.`nombre` AS `Ciudad`, count(`u`.`id`) AS `Cantidad`, `p`.`nombre` AS `Pais`
from (((`Signlator`.`usuarios` `u` join `Signlator`.`distritos` `d` on ((`u`.`distritos_id` = `d`.`id`))) join `Signlator`.`ciudades` `c` on ((`d`.`ciudades_id` = `c`.`id`)))
         join `Signlator`.`paises` `p` on ((`c`.`paises_id` = `p`.`id`)))
group by `p`.`nombre`, `c`.`nombre`;

create
    definer = root@`%` procedure Cantidad_usuario_por_pais()
BEGIN
SELECT P.nombre AS Pais,COUNT(P.id) AS Cantidad FROM usuarios U
    JOIN distritos D ON U.distritos_id = D.id
    JOIN ciudades C ON D.ciudades_id = C.id
    JOIN paises P ON C.paises_id = P.id
    GROUP BY P.nombre
    ORDER BY cantidad DESC;
END;

create
    definer = root@`%` procedure cantidad_final_progre()
BEGIN
   SELECT estado,COUNT(u.id) AS CANTIDAD FROM cursosxusuarios
   JOIN usuarios u on cursosxusuarios.usuarios_id = u.id
       GROUP BY estado;
END;

create
    definer = root@`%` function f_user_max_traducciones() returns varchar(50) deterministic
BEGIN
    declare usuario varchar(50);
    declare cant int;
    declare Texto text;
    set cant=(SELECT MAX(Cant_Traducciones) FROM v_total_traducciones_each_user);
    set usuario=(SELECT v_total_traducciones_each_user.Usuario FROM v_total_traducciones_each_user WHERE v_total_traducciones_each_user.Cant_Traducciones=cant);
    return usuario;
end;

create
    definer = root@`%` function f_usuarios_max_ciudad_per_country(Country varchar(50)) returns varchar(50) deterministic
begin
    declare Ciudad varchar(50);
    declare cant int;
    set cant = (SELECT MAX(Cantidad) from v_usuarios_ciudad_per_country where Pais=Country);
    set Ciudad = (SELECT v_usuarios_ciudad_per_country.Ciudad from v_usuarios_ciudad_per_country where v_usuarios_ciudad_per_country.Cantidad=cant) ;
    return Ciudad;
end;

create
    definer = root@`%` function f_usuarios_max_country() returns varchar(50) deterministic
begin
    declare Pais varchar(50);
    declare cant int;
    set cant = (SELECT MAX(Cantidad) from v_total_usuarios_per_country);
    set Pais = (SELECT v_total_usuarios_per_country.Pais Pais from v_total_usuarios_per_country where v_total_usuarios_per_country.Cantidad=cant);
    return Pais;
end;

create
    definer = root@`%` procedure mostrar_cursos_nombre_usuario()
BEGIN
        SELECT U.nombre AS NOMBRE,U.apellido AS APELLIDO,U.dni AS DNI,U.telefono AS TELEFONO,U.correo AS CORREO, C.nombre AS CURSO, N.nombre AS NIVEL FROM usuarios U
            JOIN cursosxusuarios CU ON U.id = CU.usuarios_id
            JOIN cursos C ON CU.cursos_id = C.id
            JOIN niveles N ON C.niveles_id = N.id
    ORDER BY U.nombre ASC;
    END;

create
    definer = root@`%` procedure p_users_info_per_country(IN Country varchar(15))
begin

        SELECT U.id as ID_Usuario, U.nombre as Usuario, p.nombre Pais, d.nombre as Distrito
        from usuarios U
            join distritos d on U.distritos_id = d.id
            join ciudades c on d.ciudades_id = c.id
            join paises p on c.paises_id = p.id
                Where p.nombre = Country;
end;

create
    definer = root@`%` procedure p_users_per_course_in_progress(IN Curso varchar(50), IN Progreso int)
begin
    SELECT U.id       as id,
           U.nombre   AS Nombre,
           U.apellido AS Apellido,
           c2.nombre  AS Curso,
           c.progreso
    FROM usuarios AS U
             JOIN cursosxusuarios c on U.id = c.usuarios_id
             JOIN cursos c2 on c.cursos_id = c2.id
    WHERE c2.nombre = curso
      AND c.progreso > Progreso
      AND c.estado = 'En progreso';
end;

create
    definer = root@`%` procedure sp_cant_traducciones_by_city_per_country(IN Country varchar(50))
BEGIN
    SELECT c.nombre Ciudad, Count(TU.traducciones_id) Traducciones
    FROM traduccionesxusuarios TU
             JOIN usuarios U on TU.usuarios_id = U.id
             JOIN distritos d on U.distritos_id = d.id
             join ciudades c on d.ciudades_id = c.id
             join paises p on c.paises_id = p.id
    WHERE p.nombre = Country
    GROUP BY c.nombre;
end;

create
    definer = root@`%` procedure sp_cant_usuario_por_curso()
BEGIN
     select c.nombre,count(U.id) as cantidad from usuarios U
        join cursosxusuarios UC on U.id = UC.usuarios_id
        join cursos c on UC.cursos_id = c.id
        join niveles n on c.niveles_id = n.id
        group by c.nombre;
end;

create
    definer = root@`%` procedure sp_cant_usuarios_no_finalizan_por_pais()
begin
select p.nombre País, count(usuarios_id) Cant_Usuarios from cursosxusuarios join usuarios u on cursosxusuarios.usuarios_id = u.id
join distritos d on u.distritos_id = d.id
join ciudades c on d.ciudades_id = c.id
join paises p on c.paises_id = p.id
where estado = 'En progreso'
group by p.nombre;
end;

create
    definer = root@`%` procedure sp_cantidad_examenes_por_curso()
BEGIN
        SELECT C.nombre AS CURSO, COUNT(*) AS CANTIDAD FROM cursos C
            JOIN unidades UN ON C.id = UN.cursos_id
            JOIN temas T ON UN.id = T.unidades_id
            JOIN examenes E ON T.id = E.temas_id
            GROUP BY CURSO
            ORDER BY CANTIDAD DESC;
    END;

create
    definer = root@`%` procedure sp_cantidad_finalizados_por_nivel()
begin
select n.nombre, count(c.usuarios_id) cantidad
from cursosxusuarios c
         join cursos c2 on c.cursos_id = c2.id
         join niveles n on c2.niveles_id = n.id
where estado = 'Finalizado'
group by n.nombre;
end;

create
    definer = root@`%` procedure sp_cantidad_por_estado()
BEGIN
   SELECT estado,COUNT(*) AS CANTIDAD FROM cursosxusuarios
       GROUP BY estado;
END;

create
    definer = root@`%` procedure sp_cantidad_temas_por_curso()
begin
select c.nombre Curso, count(t.id) cant_temas from cursos c join unidades u on c.id = u.cursos_id
join temas t on u.id = t.unidades_id
group by c.nombre;
end;

create
    definer = root@`%` procedure sp_cantidad_usuario_por_ciudad()
BEGIN
    SELECT C.nombre AS CIUDAD,COUNT(C.id) AS CANTIDAD FROM usuarios U
    JOIN distritos D ON U.distritos_id = D.id
    JOIN ciudades C ON D.ciudades_id = C.id
    GROUP BY C.nombre
    ORDER BY CANTIDAD DESC;
END;

create
    definer = root@`%` procedure sp_courses_by_nivel()
begin
    select n.nombre, count(cursos.id) Cantidad
    from cursos
             join niveles n on cursos.niveles_id = n.id
    group by n.nombre;
end;

create
    definer = root@`%` procedure sp_cursos_por_cada_usuario()
BEGIN
        SELECT U.nombre AS Usuario, Count(cursos_id) Cursos FROM usuarios U
            JOIN cursosxusuarios CU ON U.id = CU.usuarios_id
        group by U.nombre;
    END;

create
    definer = root@`%` procedure sp_examns_left_past_date(IN fecha date)
begin
        select E.descripcion as descripcion,E.peso ,E.fecha_inicio as Inicio, E.fecha_fin As Fin,c.nombre as Curso ,t.descripcion as Tema
        from examenes E
        join temas t on E.temas_id = t.id
        join unidades u on t.unidades_id = u.id
        join cursos c on u.cursos_id = c.id
        where E.fecha_inicio > fecha;

end;

create
    definer = root@`%` procedure sp_mayor_nivel_usuario()
begin
        select m.nombre,m.apellido,MAX(m.cantidad) as max from (select U.nombre as nombre,U.apellido as apellido,COUNT(*) as cantidad from usuarios U
        join cursosxusuarios CUS on U.id = CUS.usuarios_id
        join cursos C on CUS.cursos_id = C.id
        join niveles n on C.niveles_id = n.id)as m;
    end;

create
    definer = root@`%` procedure sp_total_users_per_segment(IN Segmento text)
BEGIN
    SELECT s.descripcion as Segmento, COUNT(u.id) as Quantity
    FROM segmentos AS s
             join usuarios u on s.id = u.segmentos_id
    WHERE s.descripcion = Segmento
    group by s.descripcion;
END;

create
    definer = root@`%` procedure sp_traducciones_por_usuario()
BEGIN
        SELECT U.nombre AS NOMBRE,U.dni AS DNI,TU.fecha_traduccion AS 'Fecha de traducción',M.formato AS FORMATO,L.descripcion AS LENGUAJE FROM usuarios U
            JOIN traduccionesxusuarios TU ON U.id = TU.usuarios_id
            JOIN mensajes M on TU.mensajes_id = M.id
            JOIN traducciones T on TU.traducciones_id = T.id
            JOIN lenguajes L on T.lenguajes_id = L.id;
    END;

create
    definer = root@`%` procedure sp_users_by_segment_per_country(IN Country varchar(50))
BEGIN
    SELECT s.descripcion, Count(u.id) as Quantity
    FROM segmentos AS s
             join usuarios u on s.id = u.segmentos_id
             join distritos d on u.distritos_id = d.id
             join ciudades c on d.ciudades_id = c.id
             join paises p on c.paises_id = p.id
    WHERE p.nombre = Country
    group by s.descripcion;
END;

create
    definer = root@`%` procedure sp_users_per_course_in_progress(IN Curso varchar(50), IN Progreso int)
begin
        SELECT U.id as id, U.nombre AS Nombre, U.apellido AS Apellido, c2.nombre AS Curso, c.progreso,c.fecha_inscripcion, c2.niveles_id
        FROM usuarios AS U
        JOIN cursosxusuarios c on U.id = c.usuarios_id
        JOIN cursos c2 on c.cursos_id = c2.id
        WHERE c2.nombre = curso
        AND c.progreso > Progreso
        AND c.estado = 'En progreso';
end;

create
    definer = root@`%` procedure sp_usuarios_each_nivel_per_estado(IN Estad varchar(50))
BEGIN
    SELECT N.nombre, count(u.id) Cantidad FROM niveles N join cursos c on N.id = c.niveles_id
    join cursosxusuarios c2 on c.id = c2.cursos_id
    join usuarios u on c2.usuarios_id = u.id where estado=Estad
    GROUP BY N.nombre;

end;


