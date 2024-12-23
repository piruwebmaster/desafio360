import express from "express";

import post from './endpoints/post'

const router = express.Router();
const segment = 'login'
router.use(`/${segment}`, post)

export default router;