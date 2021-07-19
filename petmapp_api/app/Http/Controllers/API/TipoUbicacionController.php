<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\TipoUbicacion;
use Illuminate\Http\Request;

class TipoUbicacionController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return TipoUbicacion::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $tipo = new TipoUbicacion(); 
        $tipo->nombre = $request->nombre;
        $tipo->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\TipoUbicacion  $tipoUbicacion
     * @return \Illuminate\Http\Response
     */
    public function show(TipoUbicacion $tipoUbicacion)
    {
        return $tipoUbicacion;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\TipoUbicacion  $tipoUbicacion
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, TipoUbicacion $tipoUbicacion)
    { 
        $tipoUbicacion->nombre = $request->nombre;
        $tipoUbicacion->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\TipoUbicacion  $tipoUbicacion
     * @return \Illuminate\Http\Response
     */
    public function destroy(TipoUbicacion $tipoUbicacion)
    {
        $tipoUbicacion->delete();
    }
}
