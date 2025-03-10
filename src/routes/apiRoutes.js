const router = require("express").Router();
const userController = require("../controllers/userController");
const orgController = require("../controllers/orgController");
const eventoController = require("../controllers/eventoController");
const ingressoController = require("../controllers/ingressoController");
const reservaController = require("../controllers/reservaController");

router.post("/user", userController.createUser);
router.get("/user", userController.getAllUsers);
router.put("/user", userController.updateUser);
router.delete("/user/:id_usuario", userController.deleteUser);
router.post("/login", userController.loginUser)

router.post("/org", orgController.createOrg);
router.get("/org", orgController.getAllOrgs);
router.put("/org", orgController.updateOrg);
router.delete("/org/:id_organizador", orgController.deleteOrg);

//rotas eventoController
router.post("/evento", eventoController.createEvento);
router.get("/evento", eventoController.getAllEventos);
router.put("/evento", eventoController.updateEvento);
router.delete("/evento/:id_evento", eventoController.deleteEvento);
router.get("/evento/data", eventoController.getEventoPorData);
router.get("/evento/:data", eventoController.getEventosPorData7Dias);

router.post("/ingresso", ingressoController.createIngresso);
router.get("/ingresso", ingressoController.getAllIngresso);
router.put("/ingresso", ingressoController.updateIngresso);
router.delete("/ingresso/:id_ingresso", ingressoController.deleteIngresso);


router.post("/reserva", reservaController.createReserva);
router.get("/reserva", reservaController.getAllReserva);
router.put("/reserva", reservaController.updateReserva);
router.delete("/reserva/:id_reserva", reservaController.deleteReserva);



module.exports = router;

