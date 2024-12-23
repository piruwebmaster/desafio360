import express from "express";
import getAll from './endpoints/getAll'
import getById from './endpoints/getById'
import deleteById from './endpoints/deleteById'
import post from './endpoints/post'
import put from './endpoints/put'

const router = express.Router();

router.use("/categories", getAll)
router.use("/categories", getById)
router.use("/categories", deleteById)
router.use("/categories", post)
router.use("/categories", put)

export default router;