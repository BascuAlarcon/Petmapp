<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Ubicacion;
use App\Models\ComentarioUbicacion;
use Illuminate\Http\Request;

class UbicacionController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Ubicacion::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $ubicacion = new Ubicacion(); 
        $ubicacion->descripcion = $request->descripcion ;
        $ubicacion->foto = $request->foto ;
        $ubicacion->direccion = $request->direccion ;
        $ubicacion->localizacion = $request->localizacion ;
        $ubicacion->tipo_ubicacion_id = $request->tipo_ubicacion ;
        $ubicacion->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Ubicacion  $ubicacion
     * @return \Illuminate\Http\Response
     */
    public function show(Ubicacion $ubicacion)
    {
        return $ubicacion;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Ubicacion  $ubicacion
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Ubicacion $ubicacion)
    { 
        $ubicacion->descripcion = $request->descripcion ;
        $ubicacion->foto = $request->foto ;
        $ubicacion->direccion = $request->direccion ;
        $ubicacion->localizacion = $request->localizacion ;
        $ubicacion->tipo_ubicacion_id = $request->tipo_ubicacion  ;
        $ubicacion->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Ubicacion  $ubicacion
     * @return \Illuminate\Http\Response
     */
    public function destroy(Ubicacion $ubicacion)
    {
        $ubicacion->delete();
    }

    public function comentarios($ubicacion){
        $comentario = ComentarioUbicacion::where('ubicacion_id', $ubicacion)->get();
        return $comentario;
    }
}
    