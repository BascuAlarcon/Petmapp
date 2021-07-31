<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Alerta;
use App\Models\ComentarioAlerta;
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
        $alerta->foto = $request->foto;
        $alerta->descripcion = $request->descripcion;
        $alerta->direccion = $request->direccion;
        $alerta->latitud = $request->latitud;
        $alerta->longitud = $request->longitud;
        $alerta->habilitado = 1;
        $alerta->ultima_actividad = $request->ultima_actividad;
        $alerta->usuario_rut = $request->usuario_rut;
        $alerta->tipo_alerta_id = $request->tipo_alerta;   
        $alerta->titulo = $request->titulo;
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
     *  Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Alerta  $alerta
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Alerta $alerta)
    {
        $alerta->tipo_alerta_id = $request->tipo_alerta;
        $alerta->foto = $request->foto;
        $alerta->descripcion = $request->descripcion;
        $alerta->direccion = $request->direccion;
        $alerta->latitud = $request->latitud;
        $alerta->longitud = $request->longitud;
        $alerta->habilitado = $request->habilitado;
        $alerta->ultima_actividad = $request->ultima_actividad;  
        $alerta->titulo = $request->titulo;
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

    public function comentarios($alerta){
        $comentario = ComentarioAlerta::where('alerta_id', $alerta)->get();
        return $comentario;
    }
 
    public function ultima(Alerta $alerta, Request $request){
        $alerta->ultima_actividad = $request->ultima_actividad;
        $alerta->save();    
    }
}
