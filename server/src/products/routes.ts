import express from "express";
import getAll from './endpoints/getAll'
import getById from './endpoints/getById'
import deleteById from './endpoints/deleteById'
import post from './endpoints/post'
import put from './endpoints/put'

const router = express.Router();

router.use("/products", getAll)
router.use("/products", getById)
router.use("/products", deleteById)
router.use("/products", post)
router.use("/products", put)

export default router;