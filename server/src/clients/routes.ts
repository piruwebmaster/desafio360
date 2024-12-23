import express from "express";
import getAll from './endpoints/getAll'
import getById from './endpoints/getById'
import deleteById from './endpoints/deleteById'
import post from './endpoints/post'
import put from './endpoints/put'

const router = express.Router();
const segment = 'clients'
router.use(`/${segment}`, getAll)
router.use(`/${segment}`, getById)
router.use(`/${segment}`, deleteById)
router.use(`/${segment}`, post)
router.use(`/${segment}`, put)

export default router;