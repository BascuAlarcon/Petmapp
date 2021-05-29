<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\ComentarioUbicacion;
use Illuminate\Http\Request;

class ComentarioUbicacionController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return ComentarioUbicacion::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $comentarioUbicacion = new ComentarioUbicacion();
        $comentarioUbicacion->descripcion = $request->descripcion ;
        $comentarioUbicacion->fecha_emision = $request->fecha_emision ;
        $comentarioUbicacion->foto = $request->foto ;
        $comentarioUbicacion->ubicacion_id = $request->ubicacion_id ;
        $comentarioUbicacion->usuario_rut = $request->usuario_rut ;
        $comentarioUbicacion->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\ComentarioUbicacion  $comentarioUbicacion
     * @return \Illuminate\Http\Response
     */
    public function show(ComentarioUbicacion $comentarioUbicacion)
    {
        return $comentarioUbicacion;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\ComentarioUbicacion  $comentarioUbicacion
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, ComentarioUbicacion $comentarioUbicacion)
    {
        $comentarioUbicacion->descripcion = $request->descripcion ;
        $comentarioUbicacion->fecha_emision = $request->fecha_emision ;
        $comentarioUbicacion->foto = $request->foto ;
        $comentarioUbicacion->ubicacion_id = $request->ubicacion_id ;
        $comentarioUbicacion->usuario_rut = $request->usuario_rut ;
        $comentarioUbicacion->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\ComentarioUbicacion  $comentarioUbicacion
     * @return \Illuminate\Http\Response
     */
    public function destroy(ComentarioUbicacion $comentarioUbicacion)
    {
        $comentarioUbicacion->delete();
    }
}
