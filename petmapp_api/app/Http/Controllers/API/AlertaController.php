<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Alerta;
use Illuminate\Http\Request;

class AlertaController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Alerta::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $alerta = new Alerta();
        $alerta->tipo_alerta = $request->tipo_alerta;
        $alerta->foto = $request->foto;
        $alerta->descripcion = $request->descripcion;
        $alerta->direccion = $request->direccion;
        $alerta->habilitado = $request->habilitado;
        $alerta->ultima_actividad = $request->ultima_actividad;
        $alerta->usuario_rut = $request->usuario_rut;
        $alerta->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Alerta  $alerta
     * @return \Illuminate\Http\Response
     */
    public function show(Alerta $alerta)
    {
        return $alerta;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Alerta  $alerta
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Alerta $alerta)
    {
        $alerta->tipo_alerta = $request->tipo_alerta;
        $alerta->foto = $request->foto;
        $alerta->descripcion = $request->descripcion;
        $alerta->direccion = $request->direccion;
        $alerta->habilitado = $request->habilitado;
        $alerta->ultima_actividad = $request->ultima_actividad;
        $alerta->usuario_rut = $request->usuario_rut;
        $alerta->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Alerta  $alerta
     * @return \Illuminate\Http\Response
     */
    public function destroy(Alerta $alerta)
    {
        $alerta->delete();
    }
}
