-- tables for task 1
create table "Person"(
	amka integer not null,
	name character(30) not null,
	father_name character(30) not null,
	surname character(30) not null,
	email character(30) not null,
	constraint "Person_pkey" primary key (amka)
); alter table "Person" owner to postgres;

create table "Room" (
	room_id integer not null,
	capacity integer not null,
	room_type type_room not null,
	constraint "Room2_pkey" primary key (room_id)
);
alter table "Room" owner to postgres;

create table "LearningActivity" (
	room_id integer not null,
	start_time integer not null check(start_time >= 8 and start_time <= 20),
	end_time integer not null check(end_time >=8 and end_time <= 20),
	weekday integer not null check(weekday >= 0 and weekday <= 6),
	serial_number integer NOT NULL DEFAULT nextval('"CourseRun_serial_number_seq"'::regclass),
	course_code character(7) COLLATE pg_catalog."default" NOT NULL,
	constraint "LearningActivity_pkey" PRIMARY KEY (room_id,start_time,end_time,weekday,course_code, serial_number),
	constraint "LearningActivity_room_id_fkey" foreign key (room_id)
	 	REFERENCES public."Room" (room_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	constraint "LearningActivity_other_fkeys" foreign key (serial_number,course_code)
		references public."CourseRun"(serial_number,course_code) match simple
		on update no action
		on delete no action
); alter table "LearningActivity" owner to postgres

create table "Participates"(
	room_id integer not null,
	start_time integer not null check(start_time >= 8 and start_time <= 20),
	end_time integer not null check(end_time >=8 and end_time <= 20),
	weekday integer not null check(weekday >= 0 and weekday <= 6),
	serial_number integer NOT NULL DEFAULT nextval('"CourseRun_serial_number_seq"'::regclass),
	course_code character(7) COLLATE pg_catalog."default" NOT NULL,
	role type_role not null,
	amka integer not null,
	constraint "Participates_pkey" primary key (room_id,start_time,end_time,weekday,serial_number,course_code,amka),
	constraint "Participates_Person_fkey" foreign key (amka)
		references public."Person"(amka) MATCH SIMPLE
		on update no action
		on delete no action,
	constraint "Participates_LA_fkey" foreign key (start_time,end_time,weekday,course_code,serial_number,room_id)
		references public."LearningActivity"(start_time,end_time,weekday,course_code,serial_number,room_id) match simple
		on update no action
		on delete no action);
	alter table "Participates" owner to postgres;
	
	
	
	