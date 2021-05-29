<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Evaluacion;
use Illuminate\Http\Request;

class EvaluacionController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Evaluacion::all();  
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $evaluacion = new Evaluacion();
        $evaluacion->nota = $request->nota;
        $evaluacion->comentario = $request->comentario;        
        $evaluacion->cuidado_id = $request->cuidado_id;
        $evaluacion->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Evaluacion  $evaluacion
     * @return \Illuminate\Http\Response
     */
    public function show(Evaluacion $evaluacion)
    {
        return $evaluacion;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Evaluacion  $evaluacion
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Evaluacion $evaluacion)
    {
        $evaluacion->nota = $request->nota;
        $evaluacion->comentario = $request->comentario;        
        $evaluacion->cuidado_id = $request->cuidado_id;
        $evaluacion->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Evaluacion  $evaluacion
     * @return \Illuminate\Http\Response
     */
    public function destroy(Evaluacion $evaluacion)
    {
        $evaluacion->delete();
    }
}
