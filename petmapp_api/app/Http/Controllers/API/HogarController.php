<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Hogar;
use Illuminate\Http\Request;

class HogarController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Hogar::all(); 
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $hogar = new Hogar();
        $hogar->tipo_hogar = $request->tipo_hogar;
        $hogar->disponibilidad_patio = $request->disponibilidad_patio;
        $hogar->direccion = $request->direccion;
        $hogar->descripcion = $request->descripcion;
        $hogar->foto = $request->foto;
        $hogar->usuario_rut = $request->usuario_rut;
        $hogar->latitud = $request->latitud;
        $hogar->longitud = $request->longitud;
        $hogar->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Hogar  $hogar
     * @return \Illuminate\Http\Response
     */
    public function show(Hogar $hogar)
    {
        return $hogar;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Hogar  $hogar
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Hogar $hogar)
    {
        $hogar->tipo_hogar = $request->tipo_hogar;
        $hogar->disponibilidad_patio = $request->disponibilidad_patio;
        $hogar->direccion = $request->direccion;
        $hogar->descripcion = $request->descripcion;
        $hogar->foto = $request->foto; 
        $hogar->latitud = $request->latitud;
        $hogar->longitud = $request->longitud;
        $hogar->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Hogar  $hogar
     * @return \Illuminate\Http\Response
     */
    public function destroy(Hogar $hogar)
    {
        $hogar->delete();
    }
}
