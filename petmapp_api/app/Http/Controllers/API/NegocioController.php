<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Negocio;
use Illuminate\Http\Request;

class NegocioController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Negocio::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $negocio = new Negocio();
        $negocio->nombre = $request->nombre ;
        $negocio->descripcion = $request->descripcion ;
        $negocio->horario = $request->horario ;
        $negocio->direccion = $request->direccion ;
        $negocio->foto = $request->foto ;
        $negocio->tipo_id = $request->tipo_id ;
        $negocio->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Negocio  $negocio
     * @return \Illuminate\Http\Response
     */
    public function show(Negocio $negocio)
    {
        return $negocio;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Negocio  $negocio
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Negocio $negocio)
    {
        $negocio->nombre = $request->nombre ;
        $negocio->descripcion = $request->descripcion ;
        $negocio->horario = $request->horario ;
        $negocio->direccion = $request->direccion ;
        $negocio->foto = $request->foto ;
        $negocio->tipo_id = $request->tipo_id ;
        $negocio->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Negocio  $negocio
     * @return \Illuminate\Http\Response
     */
    public function destroy(Negocio $negocio)
    {
        $negocio->delete();
    }
}
