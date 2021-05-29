<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\ComentarioNegocio;
use Illuminate\Http\Request;

class ComentarioNegocioController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return ComentarioNegocio::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $comentarioNegocio = new ComentarioNegocio();
        $comentarioNegocio->descripcion = $request->descripcion ;
        $comentarioNegocio->fecha_emision = $request->fecha_emision ;
        $comentarioNegocio->foto = $request->foto ;
        $comentarioNegocio->usuario_rut = $request->usuario_rut ;
        $comentarioNegocio->negocio_id = $request->negocio_id ;
        $comentarioNegocio->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\ComentarioNegocio  $comentarioNegocio
     * @return \Illuminate\Http\Response
     */
    public function show(ComentarioNegocio $comentarioNegocio)
    {
        return $comentarioNegocio;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\ComentarioNegocio  $comentarioNegocio
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, ComentarioNegocio $comentarioNegocio)
    {
        $comentarioNegocio->descripcion = $request->descripcion ;
        $comentarioNegocio->fecha_emision = $request->fecha_emision ;
        $comentarioNegocio->foto = $request->foto ;
        $comentarioNegocio->usuario_rut = $request->usuario_rut ;
        $comentarioNegocio->negocio_id = $request->negocio_id ;
        $comentarioNegocio->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\ComentarioNegocio  $comentarioNegocio
     * @return \Illuminate\Http\Response
     */
    public function destroy(ComentarioNegocio $comentarioNegocio)
    {
        $comentarioNegocio->delete();
    }
}
