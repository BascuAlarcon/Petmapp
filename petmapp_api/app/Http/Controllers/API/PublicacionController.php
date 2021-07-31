<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Publicacion;
use App\Models\Peticion;
use Illuminate\Http\Request;

class PublicacionController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Publicacion::all();  
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $publicacion = new Publicacion();
        $publicacion->descripcion = $request->descripcion;
        $publicacion->tarifa = $request->tarifa;
        $publicacion->usuario_rut = $request->usuario_rut;
        $publicacion->hogar_id = $request->hogar_id; 
        $publicacion->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Publicacion  $publicacion
     * @return \Illuminate\Http\Response
     */
    public function show(Publicacion $publicacion)
    {
        return $publicacion;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Publicacion  $publicacion
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Publicacion $publicacion)
    {
        $publicacion->descripcion = $request->descripcion;
        $publicacion->tarifa = $request->tarifa; 
        $publicacion->hogar_id = $request->hogar_id;
        $publicacion->save();
    }

    public function evaluacion(Request $request, Publicacion $publicacion)
    {
        $publicacion->nota = $request->nota;
        $publicacion->comentario = $request->comentario;  
        $publicacion->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Publicacion  $publicacion
     * @return \Illuminate\Http\Response
     */
    public function destroy(Publicacion $publicacion)
    {
        $publicacion->delete();
    }

    public function peticiones(Publicacion $publicacion){ 
        $publicacion->load('peticiones');
        return $publicacion;
    }

    public function peticiones2($publicacion){
        $peticion = Peticion::where('publicacion_id', $publicacion)->get();
        return $peticion;
    } 

    public function comentario(Request $request, Publicacion $publicacion){ 
        $publicacion->comentario = $request->comentario; 
        $publicacion->nota = $request->nota; 
        $publicacion->save();
    }
}
