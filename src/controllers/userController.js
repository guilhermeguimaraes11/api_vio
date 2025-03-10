const connect = require("../db/connect");
const validateUser = require("../services/validateUser");
const validateCpf = require("../services/validateCpf");

module.exports = class userController {
  static async createUser(req, res) {
    const { cpf, email, password, name, data_nascimento } = req.body;

    const validation = validateUser(req.body);
    if (validation) {
      return res.status(400).json(validation);
    }

    const cpfValidation = await validateCpf(cpf, null)
    if(cpfValidation){
      return res.status(400).json(cpfValidation)
    }

    const query = `
      INSERT INTO usuario (cpf, password, email, name, data_nascimento) 
      VALUES (?, ?, ?, ?, ?)
    `;
    const values = [cpf, password, email, name, data_nascimento];

    try {
      connect.query(query, values, function (err) {
        if (err) {
          console.log(err);
          if (err.code === "ER_DUP_ENTRY") {
            return res
              .status(400)
              .json({ error: "O email ou CPF já está vinculado a outro usuário" });
          } else {
            return res.status(500).json({ error: "Erro Interno do Servidor" });
          }
        } else {
          return res.status(201).json({ message: "Usuário Criado com Sucesso" });
        }
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ error: "Erro Interno do Servidor" });
    }
  }

  static async getAllUsers(req, res) {
    const query = `SELECT * FROM usuario`;

    try {
      connect.query(query, function (err, results) {
        if (err) {
          console.error(err);
          return res.status(500).json({ error: "Erro Interno do Servidor" });
        }
        return res.status(200).json({ message: "Lista de Usuários", users: results });
      });
    } catch (error) {
      console.error("Erro ao executar consulta:", error);
      return res.status(500).json({ error: "Erro Interno do Servidor" });
    }
  }

  static async updateUser(req, res) {
    const { id_usuario, name, email, password, cpf, id} = req.body;
    const validation = validateUser(req.body)
    if(validation) {
      return res.status(400).json({ error: "Todos os campos devem ser preenchidos" });
    }
    const cpfValidation = await validateCpf(cpf, id)
    if(cpfValidation){
      return res.status(400).json(cpfValidation)
    }

    const query = `UPDATE usuario SET name = ?, email = ?, password = ?, cpf = ? WHERE id_usuario = ?`;
    const values = [name, email, password, cpf, id_usuario];

    try {
      connect.query(query, values, function (err, results) {
        if (err) {
          if (err.code === "ER_DUP_ENTRY") {
            return res.status(400).json({ error: "Email já Cadastrado, por outro usuário" });
          } else {
            console.error(err);
            return res.status(500).json({ error: "Erro Interno do Servidor" });
          }
        }
        if (results.affectedRows === 0) {
          return res.status(404).json({ error: "Usuário não Encontrado" });
        }
        return res.status(200).json({ message: "Usuário atualizado com Sucesso" });
      });
    } catch (error) {
      console.error("Erro ao executar consulta: ", error);
      return res.status(500).json({ error: "Erro Interno do Servidor" });
    }
  }

  static async deleteUser(req, res) {
    const usuarioId = req.params.id_usuario;
    const query = `DELETE FROM usuario WHERE id_usuario = ?`;
    const values = [usuarioId];

    try {
      connect.query(query, values, function (err, results) {
        if (err) {
          console.error(err);
          return res.status(500).json({ error: "Erro Interno do Servidor" });
        }
        if (results.affectedRows === 0) {
          return res.status(404).json({ error: "Usuário não Encontrado" });
        }
        return res.status(200).json({ message: "Usuário Excluído com Sucesso" });
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ error: "Erro Interno do Servidor" });
    }
  }

  static async loginUser(req, res) {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: "Email e Senha são obrigatórios" });
    }

    const query = `SELECT * FROM usuario WHERE email = ?`;

    try {
      connect.query(query, [email], (err, results) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Erro Interno do Servidor" });
        }
        if (results.length === 0) {
          return res.status(401).json({ error: "Usuário Não Encontrado" });
        }

        const user = results[0];

        if (user.password !== password) {
          return res.status(403).json({ error: "Senha Incorreta" });
        }

        return res.status(200).json({ message: "Login bem-sucedido", user });
      });
    } catch (error) {
      console.log(error);
      return res.status(500).json({ error: "Erro Interno do Servidor" });
    }
  }
};
