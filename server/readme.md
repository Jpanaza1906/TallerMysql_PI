<h1 align="center"> TALLER DISEÑO E IMPLEMENTACION DE UNA BD CON MYSQL </h1>

<p align="center">
   <img src="https://img.shields.io/badge/STATUS-EN%20DESAROLLO-green">
   </p>
<h3>UNIVERSIDAD DE SAN CARLOS DE GUATEMALA

PRACTICAS INTERMEDIAS
PRIMER SEMESTRE 2024</h3>

<h1 align="center"> COMANDOS DE DOCKER </h1>


* **Creación de instancia de MySQL**

```python
docker run -d -p 3306:3306 --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
```

* **Validar nuestros contenedores**

```python
docker ps -a
```

* **Conexion desde la terminal a MySQL**

```python
docker exec -it "nombre_contenedor" mysql -p 
```


## ✒️ Autor

* **Alvaro Esaú Arenas** - *Desarrollador* - [Contacto](https://github.com/esau-arenas).


