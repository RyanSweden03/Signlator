use Signlator;

db.createCollection("cursosdetalles",{
    validator:{
        $jsonSchema:{
            bsonType:"object",
            required:["_id","curso","nivel","unidades","usuarios"],
            properties:{
                _id:{
                    bsonType:"int",
                    description:"id must be a integer and is required",
                },
                curso:{
                    bsonType:"string",
                    description:"curso must be a string and is required",
                },
                nivel:{
                    bsonType:"string",
                    description:"string must be a string and is required",
                },
                unidades:{
                    bsonType:"array",
                    description:'unidades must be an array of objects',
                    minItems:1,
                    uniqueItems:true,
                    items:{
                    bsonType: "object",
                    required:["nombre","temas"],
                    properties:{
                        nombre:{
                            bsonType:"string",
                            description:"nombre must be a string and is required"
                        },
                        temas:{
                            bsonType:"array",
                            minItems:1,
                            description:"temas must be an array of strings",
                            uniqueItems:true,
                            items:{
                                bsonType:"string"
                            }
                        }
                      }
                    }
                },
                usuarios:{
                    bsonType:'array',
                    minItems:1,
                    description:"usuarios must be an array of string",
                    uniqueItems:true,
                    items:{
                        bsonType:"string",
                    }
                }
            }
        }
    },
validationAction: "error",
validationLevel: "strict",
})

db.createCollection("examenes",{
    validator:{
    $jsonSchema:{
        bsonType: "object",
        description: "Document describing examen",
        required: ["_id", "descripcion", "peso", "fecha_inicio", "fecha_fin"],
        properties:{
            "_id": {
                bsonType: "string",
                description: "id must be a string and is required",
            },
            "descripcion":{
                bsonType: "string",
                description: "descripcion must be a string and is required",
             },

            "peso":{
                bsonType: "int",
                description: "peso must be a int and is required",
            },
            "fecha_inicio":{
                bsonType: "date",
                description: "fecha_inicio must be a date and is required"
            },
            "fecha_fin":{
                bsonType: "date",
                description: "fecha_fin must be a date and is required"
            }
        }
    }
    },
validationAction: "error",
validationLevel: "strict",
});

db.createCollection("recursos",{
    validator:{
    $jsonSchema:{
        bsonType: "object",
        description: "Document describing a recurso",
        required: ["_id", "descripcion", "titulo", "tipo", "enlace"],
        properties:{
            "_id":{
                bsonType: "string",
                description: "id must be a string and is required",
            },
            "descripcion":{
                bsonType: "string",
                description: "descripcion must be a string and is required",
            },
            "titulo":{
                bsonType: "string",
                description: "titulo must be a string and is required",
            },
            "tipo":{
                enum: ["Video", "Texto"],
                description: "tipo only can be one of enums either Video or Texto",
            },
            "enlace":{
                bsonType: "string",
                description: "enlace must be a string and is required",
            }
        }
    }
    },
validationAction: "error",
validationLevel: "strict",
});

db.createCollection("segmentos", {
    validator:{
        $jsonSchema:{
         bsonType: "object",
         required: ["_id", "caracteristicas"],
         properties:{
            _id:{
                enum: ["Persona con discapacidad auditiva", "Persona cercana a persona con discapacidad auditiva", "Persona interesada en aprender lenguaje de se??as"],
                description: "nombre must be a string and is required"
            },
            caracteristicas:{
                bsonType: "array",
                minItems:1,
                description: "caracteristicas must be an array of strings",
                uniqueItems: true,
                items:{
                    bsonType: "string",
                }
            },
            usuarios:{
                bsonType: "array",
                minItems: 1,
                description: "usuarios must be an array of string reference DNI's",
                items:{
                    bsonType: "string"
                }
            }
         }
        }
    },
validationAction: "error",
validationLevel: "strict",
}
);

db.createCollection("temas", {
    validator:{
        $jsonSchema:{
            bsonType: "object",
            description: "Document describing temas",
            required: ["nombre", "descripcion", "examenes", "recursos"],
            properties:{
                nombre: {
                bsonType: "string",
                description: "nombre must be a string and is required "
                },
                descripcion: {
                bsonType: "string",
                description: "descripcion must be a string and is required"
                },
                examenes:{
                bsonType: "array",
                minItems: 1,
                description: "unidades must be an array of strings",
                items:{
                    bsonType: "string"
                }},
                recursos:{
                bsonType: "array",
                minItems: 1,
                description: "recursos must be an array of strings",
                items:{
                    bsonType: "string"
                }
                }}
        }
    },
validationAction: "error",
validationLevel: "strict",

});

db.createCollection("usuarios", {
validator:{
    $jsonSchema: {
        bsonType: "object",
        required: ["_id","nombre", "apellido", "sexo", "correo", "cursos_inscrito", "apoderado", "telefono", "localizacion","segmento"],
        properties: {
            _id:{
                bsonType: "string",
                minLength: 8,
                description: "DNI must be a string and is required"
            },
            nombre: {
                bsonType: "string",
                description: "nombre must be a string and is required"
            },
            apellido:{
                bsonType: "string",
                description: "apellido must be a string and is optional"
            },
            sexo:{
                enum: ["Masculino", "Femenino"],
                description: "sexo can only be either 'Masculino' or 'Femenino' and is optional"
            },
            correo: {
                bsonType: "string",
                pattern: "@hotmail\.com",
                description: "Email must be a string and is required",
            },

            localizacion:{
                bsonType: "object",
                required: ["distrito", "ciudad","pais"],
                properties:{
                    distrito: {
                        bsonType: "string",
                        description: "distrito must be a string and is required"
                    },
                    ciudad:{
                        bsonType: "string",
                        description: "ciudad must be a string and is required"
                    },
                    pais: {
                        bsonType: "string",
                        description: "pais must be a string and is required"
                    }
                }
            },
            segmento:{
                enum: ["Persona con discapacidad auditiva", "Persona cercana a persona con discapacidad auditiva", "Persona interesada en aprender lenguaje de se??as"],
                description: "can only be one of the segment values and is required"
            },
            telefono:{
                bsonType: "int",
                minimum: 900000000,
                maximum: 999999999,
                description: "telefono must be an int",
            },
            cursos_inscrito: {
                bsonType: "array",
                description: "cursos inscrito must be an array of objects and is optional",
                minItems: 1,
                uniqueItems: true,
                items:{
                    bsonType: "object",
                    required: ["curso", "_id","progreso", "fecha_inscripcion", "estado"],
                }
            },
            apoderado:{
                bsonType: "object",
                description: "apoderado must be and object and is optional",
                required: ["nombre", "parentesco"],
                properties:{
                    nombre:{
                    bsonType:"string",
                    description: "nombre must be and string and is required",
                },
                    parentesco:{
                    bsonType: "string",
                    description: "parentesco must be and string and is required"
                    }
                }
            }
        },
    }
},
validationAction: "error",
validationLevel: "strict",
});


