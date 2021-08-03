<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Mascota;
use Illuminate\Http\Request;

class MascotaController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        return Mascota::all(); 
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $mascota = new Mascota();
        $mascota->nombre = $request->nombre;
        $mascota->sexo = $request->sexo;
        $mascota->estirilizacion = $request->estirilizacion; 
        $mascota->fecha_nacimiento =   $request->fecha_nacimiento; 
        $mascota->condicion_medica = $request->condicion_medica; 
        $mascota->microchip = $request->microchip;
        $mascota->alimentos = $request->alimentos; 
        $mascota->personalidad = $request->personalidad; 
        $mascota->raza_id = $request->raza_id;
        $mascota->foto = $request->foto;
        $mascota->usuario_rut = $request->usuario_rut; 
        $mascota->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Mascota  $mascota
     * @return \Illuminate\Http\Response
     */
    public function show(Mascota $mascota)
    {
        return $mascota; 
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Mascota  $mascota
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Mascota $mascota)
    {
        $mascota->nombre = $request->nombre; 
        $mascota->sexo = $request->sexo;
        $mascota->estirilizacion = $request->estirilizacion; 
        $mascota->fecha_nacimiento = $request->fecha_nacimiento; 
        $mascota->condicion_medica = $request->condicion_medica; 
        $mascota->microchip = $request->microchip;
        $mascota->alimentos = $request->alimentos; 
        $mascota->personalidad = $request->personalidad; 
        $mascota->raza_id = $request->raza_id;
        $mascota->foto = $request->foto;
        $mascota->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Mascota  $mascota
     * @return \Illuminate\Http\Response
     */
    public function destroy(Mascota $mascota)
    {
        $mascota->delete();
    }
}
