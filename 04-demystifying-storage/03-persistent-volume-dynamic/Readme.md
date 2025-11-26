### Applying all manifests file

```bash
kubectl apply -f 01-mysql-secrets.yaml
kubectl apply -f 02-mysql-pv.yaml
kubectl apply -f 03-mysql-pvc.yaml
kubectl apply -f 04-storage-class.yaml
kubectl apply -f 05-mysql-deployment.yaml
kubectl apply -f 06-mysql-service.yaml
```

### Forwarding to localhost the port

```bash
kubectl port-forward svc/mysql-nodeport-svc-sp 30306:3306
```

### login from terminal or MySQL Workbench

```bash
mysql -h 127.0.0.1 -P 30306 -u root -p # For root user
mysql -h 127.0.0.1 -P 30306 -u jakir -p # For other user like jakir
```

**NB**: You should use `username` & `password` based on secrets.

### Create a user, give password & privilege

```sql
CREATE USER 'jasim'@'%' IDENTIFIED BY 'Sql@054003';
GRANT ALL PRIVILEGES ON *.* TO 'jasim'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

### Try to login

```bash
mysql -h 127.0.0.1 -P 30306 -u jasim -p
```

### Create a database and a table

```sql
CREATE DATABASE dbstudents;
```

```sql
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT,
    enrolled_date DATE
);
```

### Restart/Delete the pod

```bash
kubectl get pod
kubectl delete pod mysql-deployment-969c8685b-46hhf
```

### Again try to login

```bash
kubectl port-forward svc/mysql-nodeport-svc-sp 30306:3306
mysql -h 127.0.0.1 -P 30306 -u root -p
```

### Check database

```sql
USE DatabaseName;
SHOW TABLES;
```

> NB: Exists the MySQL database
