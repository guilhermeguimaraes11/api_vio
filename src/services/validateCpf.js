const connect = require("../db/connect");

module.exports = async function validateUser(cpf, userId) {
  const query = "SELECT id_usuario from usuario WHERE cpf=?";
  const values = [cpf];

 await connect.query(query, values,(err, results)=>{
    if(err){
        //fazer algo
    }
    else if(results.length > 0){
        const idDoCpfCadastrado = results[0].id_usuario;

        if(userId && idDoCpfCadastrado !== userId){
            return {error:"CPF já cadastrado para outro usuário"}
        }else if (!userId){
            return{error:"CPF já cadastrado"}
        }
    }
    else{
        return null;
    }
  });
};
