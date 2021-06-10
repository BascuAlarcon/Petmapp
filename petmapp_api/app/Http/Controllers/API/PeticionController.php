<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Peticion;
use Illuminate\Http\Request;

class PeticionController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Peticion::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $peticion = new Peticion();
        $peticion->fecha_inicio = $request->fecha_inicio;
        $peticion->fecha_fin = $request->fecha_fin;
        // $peticion->precio_total = $request->precio_total;
        $peticion->estado = 1;
        // $peticion->boleta = $request->boleta; 
        $peticion->usuario_rut = $request->usuario_rut;
        $peticion->publicacion_id = $request->publicacion_id;
        $peticion->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Peticion  $peticion
     * @return \Illuminate\Http\Response
     */
    public function show(Peticion $peticion)
    {
        return $peticion;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Peticion  $peticion
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Peticion $peticion)
    {
        $peticion->fecha_inicio = $request->fecha_inicio;
        $peticion->fecha_fin = $request->fecha_fin;
        $peticion->precio_total = $request->precio_total;
        $peticion->estado = $request->estado;
        $peticion->boleta = $request->boleta; 
        $peticion->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Peticion  $peticion
     * @return \Illuminate\Http\Response
     */
    public function destroy(Peticion $peticion)
    {
        $peticion->delete(); 
    }

    public function respuesta(Request $request, Peticion $peticion){ 
        $peticion->estado = $request->estado; 
        $peticion->save();
    }
}
