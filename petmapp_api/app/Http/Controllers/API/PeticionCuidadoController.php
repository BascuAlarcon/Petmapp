<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\PeticionCuidado;
use Illuminate\Http\Request;

class PeticionCuidadoController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return PeticionCuidado::all();  
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $peticionCuidado = new PeticionCuidado(); 
        $peticionCuidado->fecha_inicio = $request->fecha_inicio;
        $peticionCuidado->fecha_fin = $request->fecha_fin;
        $peticionCuidado->precio_total = $request->precio_total;
        $peticionCuidado->estado = $request->estado;
        $peticionCuidado->publicacion_id = $request->publicacion_id;
        $peticionCuidado->usuario_rut = $request->usuario_rut;
        $peticionCuidado->boleta = $request->boleta;
        $peticionCuidado->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\PeticionCuidado  $peticionCuidado
     * @return \Illuminate\Http\Response
     */
    public function show(PeticionCuidado $peticionCuidado)
    {
        return $peticionCuidado;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\PeticionCuidado  $peticionCuidado
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, PeticionCuidado $peticionCuidado)
    {
        $peticionCuidado->fecha_inicio = $request->fecha_inicio;
        $peticionCuidado->fecha_fin = $request->fecha_fin;
        $peticionCuidado->precio_total = $request->precio_total;
        $peticionCuidado->estado = $request->estado;
        $peticionCuidado->publicacion_id = $request->publicacion_id;
        $peticionCuidado->usuario_rut = $request->usuario_rut;
        $peticionCuidado->boleta = $request->boleta;
        $peticionCuidado->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\PeticionCuidado  $peticionCuidado
     * @return \Illuminate\Http\Response
     */
    public function destroy(PeticionCuidado $peticionCuidado)
    {
        $peticionCuidado->delete();
    }
}
